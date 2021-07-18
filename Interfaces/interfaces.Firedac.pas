unit interfaces.firedac;

interface

uses
  interfaces.DAO, Datasnap.DBClient;

type
   iFireDac = interface
      ['{B206B371-A502-4DE4-B3A6-444FB9D85964}']
      function SelectRazaoSocial(_ADAOFiredac: iDaoFiredac): TClientDataset;
   end;

implementation

end.
