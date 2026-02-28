package ty

type Expr interface{ isExpr() }
type Type interface{ isType() }

type ExprInt int

func (ExprInt) isExpr() {}

type ExprVar string

func (ExprVar) isExpr() {}

type ExprFun struct {
	Param ExprVar
	Body  Expr
}

func (*ExprFun) isExpr() {}

type ExprApp struct {
	Callee Expr
	Arg    Expr
}

func (*ExprApp) isExpr() {}

type ExprVarTyped struct {
	Var  ExprVar
	Type Type
}

func (*ExprVarTyped) isExpr() {}

type TypeInt struct{}

func (TypeInt) isType() {}

type TypeFun struct {
	Param Type
	Ret   Type
}

func (*TypeFun) isType() {}

type TypeVar string

func (TypeVar) isType() {}

type TypeInference struct {
	unificationTable map[TypeVar]Type
}

type Constraint interface{ isConstraint() }

type TypeEqual struct {
	NodeId int
	T1     Type
	T2     Type
}

func (*TypeEqual) isConstraint() {}
