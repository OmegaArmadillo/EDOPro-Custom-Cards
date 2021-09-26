--HERO Evolution
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end


function s.costFilter(c)
	return c:IsSetCard(0x8)
end


function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,s.costFilter,1,false,nil,e:GetHandler()) end
	local g=Duel.SelectReleaseGroupCost(tp,s.costFilter,1,1,false,nil,e:GetHandler())
	local tm=g:GetFirst()
	e:SetLabel(tm)
	Duel.Release(g,REASON_COST)
end


function s.thfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end

function s.filter1(c,e,tp)
	return c:IsSetCard(0x8) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.filter2(c,e,tp,att)
	return c:IsSetCard(0x8) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsAttribute(att)
end

function s.filter3(c,e,tp,lv,att)
	return c:IsSetCard(0x8) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (c:IsLevel(lv) or c:IsLevel(lv+1)) and c:IsAttribute(att)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	
	local tm=e:GetLabel()
	local lv=tm:GetLevel()
	local att=tm:GetAttribute()


	local b1=Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
	local b2=Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,att)
	local b3=Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp,lv,att)
	if chk==0 then return b1 or b2 or b3 end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(id,0)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(id,1)
		opval[off-1]=2
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(id,2)
		opval[off-1]=3
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	e:SetLabel(sel)
	if sel==1 then
		local g=Duel.SelectTarget(tp,s.filter1,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	elseif sel==2 then
		local g=Duel.SelectTarget(tp,s.filter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	else
		local g=Duel.SelectTarget(tp,s.filter3,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	if sel==1 then
			local tc=Duel.GetFirstTarget()
			if tc:IsRelateToEffect(e) then
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
	elseif sel==2 then
			local tc=Duel.GetFirstTarget()
			if tc:IsRelateToEffect(e) then
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
	else
			local tc=Duel.GetFirstTarget()
			if tc:IsRelateToEffect(e) then
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
	end
end
