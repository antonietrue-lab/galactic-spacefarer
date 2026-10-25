using SpacefarerService as service from '../../srv/service';

annotate service.Spacefarers with @(
  UI.HeaderInfo: {
    TypeName: 'Spacefarer', TypeNamePlural: 'Spacefarers',
    Title: { Value: name }, Description: { Value: positionName }
  },
  UI.SelectionFields: [ originPlanet_code, department_code, spacesuitColor ],
  UI.LineItem: [
    { Value: name, Label: 'Name' },
    { Value: originPlanetName, Label: 'Origin Planet' },
    { Value: stardustCollection, Label: 'Stardust collection', Criticality: stardustCriticality },
    { Value: wormholeNavigationSkill, Label: 'Wormhole navigation skill' },
    { Value: spacesuitColor, Label: 'Spacesuit color' },
    { Value: departmentName, Label: 'Department' }
  ],
  UI.Facets: [
    { $Type: 'UI.ReferenceFacet', Label: 'General', Target: '@UI.FieldGroup#General' },
    { $Type: 'UI.ReferenceFacet', Label: 'Cosmic Details', Target: '@UI.FieldGroup#Cosmic' }
  ],
  UI.FieldGroup #General: { Data: [
    { Value: name, Label: 'Name' },
    { Value: originPlanet_code, Label: 'Origin Planet' },
    { Value: email, Label: 'Email' },
    { Value: department_code, Label: 'Department' },
    { Value: position_code, Label: 'Position' }
  ]},
  UI.FieldGroup #Cosmic: { Data: [
    { Value: stardustCollection, Label: 'Stardust collection' },
    { Value: wormholeNavigationSkill, Label: 'Wormhole navigation skill' },
    { Value: spacesuitColor, Label: 'Spacesuit color' }
  ]}
);

annotate service.Spacefarers with {
  originPlanet @(
    Common.Text                     : originPlanet.name,
    Common.TextArrangement          : #TextOnly,
    Common.ValueListWithFixedValues : true,
    Common.ValueList : {
      CollectionPath : 'Planets',
      Parameters : [
        { $Type : 'Common.ValueListParameterInOut',
          LocalDataProperty : originPlanet_code,
          ValueListProperty : 'code' }
      ]
    }
  );

  department @(
    Common.Text                     : department.name,
    Common.TextArrangement          : #TextOnly,
    Common.ValueListWithFixedValues : true,
    Common.ValueList : {
      CollectionPath : 'Departments',
      Parameters : [
        { $Type : 'Common.ValueListParameterInOut',
          LocalDataProperty : department_code,
          ValueListProperty : 'code' }
      ]
    }
  );

  position @(
    Common.Text                     : position.name,
    Common.TextArrangement          : #TextOnly,
    Common.ValueListWithFixedValues : true,
    Common.ValueList : {
      CollectionPath : 'Positions',
      Parameters : [
        { $Type : 'Common.ValueListParameterInOut',
          LocalDataProperty : position_code,
          ValueListProperty : 'code' }
      ]
    }
  );
};

annotate service.Spacefarers with {
  name                    @title: 'Name'                      @Core.Immutable;
  email                   @title: 'Email'                     @Core.Immutable;
  originPlanet            @title: 'Origin Planet'             @Core.Immutable;
  department              @title: 'Department'                @Core.Immutable;
  position                @title: 'Position'                  @Core.Immutable;
  wormholeNavigationSkill @title: 'Wormhole navigation skill' @Core.Immutable;
  stardustCollection      @title: 'Stardust collection';
  spacesuitColor          @title: 'Spacesuit color';
};

annotate service.Planets     with { code @Common.Text: name @Common.TextArrangement: #TextOnly; };
annotate service.Departments with { code @Common.Text: name @Common.TextArrangement: #TextOnly; };
annotate service.Positions   with { code @Common.Text: name @Common.TextArrangement: #TextOnly; };