--Elemental HERO Cutting Bladedge
local s,id=GetID()
function s.initial_effect(c)
	
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
end

function s.spfilter1(c)
	return c:IsSetCard(0x8) and c:IsAbleToRemoveAsCost() and aux.SpElimFilter(c,true,true)
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetMatchingGroup(s.spfilter1,tp,LOCATION_ONFIELD,0,nil)

	return Duel.CheckReleaseGroup(c:GetControler(),Card.IsSetCard,1,false,1,true,c,c:GetControler(),nil,false,nil,0x8) and aux.SelectUnselectGroup(rg,e,tp,1,1,aux.ChkfMMZ(1),0)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,c)
	--tribute
	local g=Duel.SelectReleaseGroup(tp,Card.IsSetCard,1,1,false,true,true,c,nil,nil,false,nil,0x8)

	--banish
	local rg=Duel.GetMatchingGroup(s.spfilter1,tp,LOCATION_GRAVE,0,nil)
	local h=aux.SelectUnselectGroup(rg,e,tp,1,1,aux.ChkfMMZ(1),1,tp,HINTMSG_REMOVE,nil,nil,true)

	if g and #h>0 then
		g:KeepAlive()
		e:SetLabelObject(g)

		h:KeepAlive()
		e:SetLabelObject(h)
	return true
	end
	return false
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject(g)
	local h=e:GetLabelObject(h)
	if not g and not h then return end
	Duel.Release(h,REASON_COST)
	Duel.Remove(h,POS_FACEUP,REASON_COST)
	g:DeleteGroup()
h:DeleteGroup()
end