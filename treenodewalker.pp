unit TreeNodeWalker;

{$mode delphi}

interface

type

  { TNodeWalker }

  TNodeWalker = class(TTreeView)
  private
		FOutList : TStringList;
		FCandidateList : TStringList;    // FPrepList is what is compared to database
    rootNode: TTreeNode;
    FTree: TTreeView;
    FLeaves: TFPGObjectList<TTreeNode>;
    FTreeHeight, FTreeWidth : Integer;

		function GetFromDb : TStringList;
		function GetLimitClause : String;
    function get_top_level_node_into_array: Integer;
    // Deprecated: procedure walkParentSubTree(_node : TTreeNode; const howWide : Integer);

    procedure SetTree(const Value: TTreeView);
    procedure processTree;
		function walkParent_the_Tree(parent_node : TTreeNode;
                                         lvl : Integer = 0): Integer;
  public
    FParentNodeAra : array of TTreeNode;
    FLimitClause : String;
    property LimitClause : String read FLimitClause write FLimitClause;
    property Tree: TTreeView write SetTree;
    constructor Create(const aOwner: TComponent; tvu : TTreeView;
                        const height, width : Integer);
    destructor Destroy; override;
    property OutList : TStringList read FOutList;
    property PrepList : TStringList read FCandidateList;
    property TreeWidth : Integer read FTreeWidth write FTreeWidth;
    property TreeHeight : Integer read FTreeHeight write FTreeHeight;
  end;


uses
      Classes, SysUtils;

implementation

end.

