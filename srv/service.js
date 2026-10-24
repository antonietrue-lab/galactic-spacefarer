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

      if (!d.originPlanet_code) d.originPlanet_code = req.user.attr?.planet;
    });

    this.after('CREATE', Spacefarers, async (data) => {
      try {
        const transport = nodemailer.createTransport({ jsonTransport: true });
        const info = await transport.sendMail({
          from: 'mission@spaceadventures.com',
          to: data.email,
          subject: 'Welcome aboard, Spacefarer, you did it!',
          text: `Congratulations ${data.name}! Your adventure begins now, let's meet in the ship!`
        });
        LOG.info('Welcome mail:', info.message);
      } catch (e) {
        LOG.error('Mail failed', e);
      }
    });

    return super.init();
  }
};