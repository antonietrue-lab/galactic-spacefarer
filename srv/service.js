import cds from '@sap/cds';
import nodemailer from 'nodemailer';

const LOG = cds.log('spacefarer');

export default class SpacefarerService extends cds.ApplicationService {
  init() {
    const { Spacefarers } = this.entities;

    this.before('CREATE', Spacefarers, req => {
      const d = req.data;

      if (d.wormholeNavigationSkill != null &&
        (d.wormholeNavigationSkill < 1 || d.wormholeNavigationSkill > 10)) {
        return req.error(400, 'Wormhole navigation skill must be between 1 and 10', 'wormholeNavigationSkill');
      }
      if (d.stardustCollection != null && d.stardustCollection < 0) {
        return req.error(400, 'Stardust collection cannot be negative', 'stardustCollection');
      }

      d.wormholeNavigationSkill ??= 1;
      d.stardustCollection ??= 100;
      if (d.wormholeNavigationSkill >= 8) d.stardustCollection += 50;

      if (d.email && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(d.email)) {
        return req.error(400, 'Invalid email address format! (spacefarer@example.com)', 'email');
      }

      if (!d.originPlanet_code) d.originPlanet_code = req.user.attr?.planet;
    });

    const PROTECTED = ['name', 'email', 'originPlanet_code', 'department_code',
      'position_code', 'wormholeNavigationSkill'];

    this.before('UPDATE', Spacefarers, async req => {
      const { Spacefarers: DbSpacefarers } = cds.entities('galactic');
      const current = await cds.tx(req).run(
        SELECT.one.from(DbSpacefarers).where({ ID: req.data.ID })
      );
      if (!current) return;

      const changed = PROTECTED.filter(f => f in req.data && req.data[f] !== current[f]);
      if (changed.length) {
        return req.reject(400, `Only stardust collection and spacesuit color can be modified (${changed.join(', ')})`);
      }
    });

    this.after('CREATE', Spacefarers, async (data, req) => {
      try {
        const { Spacefarers: DbSpacefarers } = cds.entities('galactic');
        const id = data?.ID ?? req.data?.ID;
        const sf = await cds.tx(req).run(
          SELECT.one.from(DbSpacefarers).where({ ID: id })
        );

        const transport = nodemailer.createTransport({ jsonTransport: true });
        const info = await transport.sendMail({
          from: 'mission@spaceadventures.com',
          to: sf.email,
          subject: 'Welcome aboard, Spacefarer, you did it!',
          text: `Congratulations ${sf.name}! Your adventure begins now, let's meet in the ship!`
        });
        LOG.info('Welcome mail:', info.message);
      } catch (e) {
        LOG.error('Mail failed', e);
      }
    });

    return super.init();
  }
};