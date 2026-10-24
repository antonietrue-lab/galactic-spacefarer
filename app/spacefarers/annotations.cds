using SpacefarerService as service from '../../srv/service';

annotate service.Spacefarers with @(
  UI.HeaderInfo: {
    TypeName: 'Spacefarer', TypeNamePlural: 'Spacefarers',
    Title: { Value: name }, Description: { Value: positionName }
  },
  UI.SelectionFields: [ originPlanet, department_code, spacesuitColor ],
  UI.LineItem: [
    { Value: name, Label: 'Name'},
    { Value: originPlanetName, Label: 'Origin Planet'},
    { Value: stardustCollection, Label : 'Stardust collection', Criticality: stardustCriticality},
    { Value: wormholeNavigationSkill, Label : 'Wormhole navigation skill'},
    { Value: spacesuitColor, Label : 'Spacesuit color'},
    { Value: departmentName, Label: 'Department'}
  ],
  UI.Facets: [
    { $Type: 'UI.ReferenceFacet', Label: 'General',  Target: '@UI.FieldGroup#General' },
    { $Type: 'UI.ReferenceFacet', Label: 'Cosmic Details', Target: '@UI.FieldGroup#Cosmic' }
  ],
  UI.FieldGroup #General: { Data: [
    { Value: name, Label: 'Name'}, { Value: originPlanet_code, Label: 'Origin Planet'}, { Value: email, Label : 'Email'},
    { Value: department_code, Label: 'Department'}, { Value: position_code, Label : 'Position'}
  ]},
  UI.FieldGroup #Cosmic: { Data: [
    { Value: stardustCollection, Label : 'Stardust collection'}, { Value: wormholeNavigationSkill, Label : 'Wormhole navigation skill'}, { Value: spacesuitColor, Label : 'Spacesuit color' }
  ]}
);

annotate service.Spacefarers with {
  originPlanet @Common.Text: originPlanet.name @Common.TextArrangement: #TextOnly;
  department   @Common.Text: department.name    @Common.TextArrangement: #TextOnly;
  position     @Common.Text: position.name      @Common.TextArrangement: #TextOnly;
};