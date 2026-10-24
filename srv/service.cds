using galactic from '../db/schema';

service SpacefarerService @(path: '/spacefarer', requires: 'authenticated-user') {

  @odata.draft.enabled
  @restrict: [
    { grant: 'READ', to: ['Viewer','Commander'], where: 'originPlanet_code = $user.planet' },
    { grant: ['CREATE','UPDATE','DELETE'], to: 'Commander' }
  ]
  entity Spacefarers as projection on galactic.Spacefarers {
    *,
    originPlanet.name as originPlanetName : String,
    position.name   as positionName   : String,
    department.name as departmentName : String,
    case when stardustCollection >= 1000 then 3
         when stardustCollection >= 100  then 2
         else 1 end as stardustCriticality : Integer
  };

  @readonly entity Departments as projection on galactic.Departments;
  @readonly entity Positions   as projection on galactic.Positions;
  @readonly entity Planets     as projection on galactic.Planets;
}