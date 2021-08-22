--Elemental HERO Feral Wildheart
local s,id=GetID()
function s.initial_effect(c)
	

	--Activate(effect)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCondition(s.condition2)
	e1:SetTarget(s.target2)
	e1:SetOperation(s.activate2)
	c:RegisterEffect(e1)


	--Unaffected by activated effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetCondition(s.unacon)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(s.unaval)
	c:RegisterEffect(e2)

	--attack boost
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.atkcon)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x8))
	e3:SetValue(300)
	c:RegisterEffect(e3)
end


function s.condition2(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and ep~=tp
		and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_TRAP) and Duel.IsChainNegatable(ev)
end

function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,LOCATION_GRAVE)
end
function s.activate2(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
	Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP)	
 Duel.SpecialSummonComplete()
end


--effect 2
function s.unafilter(c)
	return c:IsFaceup() and c:IsSetCard(0x8) and c:IsLevelBelow(7) and not c:IsType(TYPE_FUSION)
end
function s.unacon(e)
	return Duel.IsExistingMatchingCard(s.unafilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,3,nil)
end
function s.unaval(e,te)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x8))
	e1:SetValue(s.efilter)
	Duel.RegisterEffect(e1,tp)
end

function s.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer() and re:IsActivated()
end

--effect 3
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph>=0x08 and ph<=0x80
end