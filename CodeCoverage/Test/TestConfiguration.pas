unit TestConfiguration;
{

 Delphi DUnit Test Case
 ----------------------
 This unit contains a skeleton test case class generated by the Test Case Wizard.
 Modify the generated code to correctly setup and call the methods from the unit
 being tested.

}

interface

uses
  TestFramework, classes, Configuration, sysutils;

type
  // Test methods for class TCoverageConfiguration

  TestTCoverageConfiguration = class(TTestCase)
  strict private
    FCoverageConfiguration: TCoverageConfiguration;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestIncompleteCommandLine;
   procedure TestNoMapFile;

  end;

  TMockCommandLineProvider = class(TParameterProvider)
  private
    params: TStringList;
  public
    constructor create(stringarray: array of string);
    function ParamCount: Integer; override;
    function ParamString(index: Integer): string; override;
  end;

const
  incompleteparams: array [0 .. 1] of string = ('-m', 'mapfile.map');
const
  nomapfileparams: array [0 .. 0] of string = ('-m');

implementation

constructor TMockCommandLineProvider.create(stringarray: array of string);
var
  i: Integer;
begin
  params := TStringList.create;
  for i := 0 to length(stringarray) - 1 do
  begin
    params.add(stringarray[i]);
  end;
end;

function TMockCommandLineProvider.ParamCount: Integer;
begin
  result := params.count;
end;

function TMockCommandLineProvider.ParamString(index: Integer): string;
begin
 if index>ParamCount then raise EParameterIndexException.Create('Parameter Index:' + IntToStr(index) + ' out of bounds.');
 result := params[index - 1];
end;

procedure TestTCoverageConfiguration.SetUp;
begin
end;

procedure TestTCoverageConfiguration.TearDown;
begin
end;

procedure TestTCoverageConfiguration.TestNoMapFile;
var
  coverageConf: TCoverageConfiguration;
begin
  coverageConf := TCoverageConfiguration.create(TMockCommandLineProvider.create(incompleteparams));
  coverageConf.ParseCommandLine;
  Check(not(coverageConf.isComplete), 'Configuration should not be complete based on these parameters');
  Check(coverageConf.getMapFile() = 'mapfile.map', 'Mapfile was:' + coverageConf.getMapFile());
end;

procedure TestTCoverageConfiguration.TestIncompleteCommandLine;
var
  coverageConf: TCoverageConfiguration;
begin
  coverageConf := TCoverageConfiguration.create(TMockCommandLineProvider.create(nomapfileparams));
  try
    coverageConf.ParseCommandLine;
  except
    on EConfigurationException do
      Check(True, 'Expected ConfigurationException detected');
  end;
end;

initialization

// Register any test cases with the test runner
RegisterTest(TestTCoverageConfiguration.Suite);

end.