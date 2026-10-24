namespace galactic;

using { cuid, managed } from '@sap/cds/common';

entity Spacefarers : cuid, managed {
  name                    : String(100) @mandatory;
  email                   : String(255) @mandatory;
  originPlanet            : Association to Planets @mandatory;
  stardustCollection      : Integer default 0;
  wormholeNavigationSkill : Integer default 1;   // 1-10
  spacesuitColor          : String(20);
  department              : Association to Departments;
  position                : Association to Positions;
}

entity Departments { key code : String(10); name : String(100); }
entity Positions   { key code : String(10); name : String(100); }
entity Planets     { key code : String(10); name : String(100); }