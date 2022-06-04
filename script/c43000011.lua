--HERO Evolution
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	e1:SetLabel(0)
	c:RegisterEffect(e1)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function s.costfilter(c,e,tp)
	return c:IsFaceup() and c:GetOriginalLevel()>0 and (Duel.IsExistingMatchingCard(s.spfilter1,tp,LOCATION_HAND,0,1,nil,c,e,tp) or Duel.IsExistingMatchingCard(s.spfilter2,tp,LOCATION_GRAVE,0,1,nil,c,e,tp) or Duel.IsExistingMatchingCard(s.spfilter3,tp,LOCATION_DECK,0,1,nil,c,e,tp)) and c:IsSetCard(0x8)
end
function s.spfilter1(c,tc,e,tp)
	return c:IsSetCard(0x8)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.spfilter2(c,tc,e,tp)
	return c:IsSetCard(0x8)
		and c:GetOriginalAttribute()==tc:GetOriginalAttribute()
		and c:GetOriginalCode()~=tc:GetOriginalCode()
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.spfilter3(c,tc,e,tp)
	return c:IsSetCard(0x8)
		and c:GetOriginalAttribute()==tc:GetOriginalAttribute()
		and (c:GetOriginalLevel()==tc:GetOriginalLevel() or c:GetOriginalLevel()==tc:GetOriginalLevel()+1)
		and c:GetOriginalCode()~=tc:GetOriginalCode()	  
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)

	--local c=e:GetHandler()
	if chk==0 then


		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return e:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
			and Duel.CheckReleaseGroupCost(tp,s.costfilter,1,false,nil,nil,e,tp)
		end

	   local sel=0
		if Duel.IsExistingMatchingCard(s.spfilter1,tp,LOCATION_HAND,0,1,nil) 
		then sel=sel+1 end
		if Duel.IsExistingMatchingCard(s.spfilter2,tp,LOCATION_GRAVE,0,1,nil) then sel=sel+2 end
		if Duel.IsExistingMatchingCard(s.spfilter3,tp,LOCATION_DECK,0,1,nil) then sel=sel+3 end
		e:SetLabel(sel)
		return sel~=0
 
	end


	local sel=e:GetLabel()
	if sel==4 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,0))
		sel=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2),aux.Stringid(id,3))+1
	elseif sel==1 then
		Duel.SelectOption(tp,aux.Stringid(id,1))
	elseif sel==2 then
		Duel.SelectOption(tp,aux.Stringid(id,2))
	else
		Duel.SelectOption(tp,aux.Stringid(id,3))
	end
	e:SetLabel(sel)
	if sel==1 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	elseif sel==2 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	else
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	end


	e:SetLabel(0)
	local g=Duel.SelectReleaseGroupCost(tp,s.costfilter,1,1,false,nil,nil,e,tp)
	Duel.Release(g,REASON_COST)
	Duel.SetTargetCard(g)

end
function s.activate(e,tp,eg,ep,ev,re,r,rp)


	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)



--	local c=e:GetHandler()
	local sel=e:GetLabel()
	if sel==1 then
			local g=Duel.SelectMatchingCard(tp,s.spfilter1,tp,LOCATION_HAND,0,1,1,nil,tc,e,tp)
			if #g>0 then
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
	elseif sel==2 then
			local g=Duel.SelectMatchingCard(tp,s.spfilter2,tp,LOCATION_GRAVE,0,1,1,nil,tc,e,tp)
			if #g>0 then
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
	else
			local g=Duel.SelectMatchingCard(tp,s.spfilter3,tp,LOCATION_DECK,0,1,1,nil,tc,e,tp)
			if #g>0 then
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
	end
end

