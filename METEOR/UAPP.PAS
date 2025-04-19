{
  uapp unit
  Represents a Meteor app
  2025 LRT
}
unit
  uapp;

interface

  uses
    consts, utils, types, locale,
    uobject, uexc;

  const
    C_MeteorApp_CLASSNAME = 'TMeteorApp';

  type
    EMeteorAppState = (
      EMeteorAppStateInitial,
      EMeteorAppStateRunning,
      EMeteorAppStateStopped
    );

    PMeteorApp = ^TMeteorApp;
    TMeteorApp = object (TObject)
    public
      constructor init;
      destructor done; virtual;
      function getClassName: string; virtual;
      function getState: EMeteorAppState;
      procedure processMessages;
      procedure run;
    private
      _state: EMeteorAppState;
    end;

implementation

  { TMeteorApp public }

  constructor TMeteorApp.init;
  begin
    inherited init;
    _state := EMeteorAppStateInitial;
  end;

  destructor TMeteorApp.done;
  begin
    inherited done;
  end;

  procedure TMeteorApp.processMessages;
  begin
  end;

  procedure TMeteorApp.run;
  begin
  end;

  function TMeteorApp.getState: EMeteorAppState;
  begin
    getState := _state;
  end;

  function TMeteorApp.getClassName: string;
  begin
    getClassName := C_MeteorApp_CLASSNAME;
  end;

  { TMeteorApp private }

  { Other }

end.
