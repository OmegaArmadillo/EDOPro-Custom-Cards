--Elemental HERO Cutting Bladedge
local s,id=GetID()
function s.initial_effect(c)
   
   local e1=Effect.CreateEffect(c)
   e1:SetDescription(aux.Stringid(id,1))
   e1:SetType(EFFECT_TYPE_IGNITION)
   e1:SetCode(EFFECT_SPSUMMON_PROC)
   e1:SetRange(LOCATION_HAND)  
   e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON) 
   e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH) 
   e1:SetTarget(s.sptg)
   e1:SetOperation(s.spop)
   c:RegisterEffect(e1)


	--banish,burn,search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCondition(aux.bdgcon)
	e2:SetTarget(s.damtg)
	e2:SetOperation(s.damop)
	c:RegisterEffect(e2)
end

s.listed_series={0x8}

--effect 1
function s.tbfilter(c,ft)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x8)
end
function s.rmfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x8) and c:IsAbleToRemove()
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
   local c=e:GetHandler()
	if chkc then return false end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>-1 and Duel.IsExistingTarget(s.tbfilter,tp,LOCATION_MZONE,0,1,nil,ft)
		and Duel.IsExistingTarget(s.rmfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectTarget(tp,s.tbfilter,tp,LOCATION_MZONE,0,1,1,nil,ft)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectTarget(tp,s.rmfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g1,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g2,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)

end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ex,g1=Duel.GetOperationInfo(0,CATEGORY_TOGRAVE)
	local ex,g2=Duel.GetOperationInfo(0,CATEGORY_REMOVE)
	local tc1=g1:GetFirst()
	if not tc1:IsRelateToEffect(e) or Duel.SendtoGrave(tc1,REASON_EFFECT)==0 then return end
	local tc2=g2:GetFirst()
	if not tc2:IsRelateToEffect(e) or Duel.Remove(tc2,POS_FACEUP,REASON_EFFECT)==0 then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
   -- Duel.BreakEffect()
  --  Duel.Recover(tp,1250,REASON_EFFECT)
end




--burn effect


function s.adamtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return 
	Duel.IsExistingMatchingCard(s.schfilter,tp,LOCATION_DECK,0,1,nil) end
	local bc=e:GetHandler():GetBattleTarget()
	Duel.SetTargetCard(bc)
	local dam=bc:GetDefense()
	if dam<0 then dam=0 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function s.adamop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then	
		  if Duel.Remove(tc,0,REASON_EFFECT) then
				local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
				local dam=tc:GetDefense()
				local lev=tc:GetLevel()
				if dam<0 then dam=0 end
					if Duel.Damage(p,dam,REASON_EFFECT) and Duel.IsExistingMatchingCard(s.schfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
						local g=Duel.SelectMatchingCard(tp,s.schfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
						if #g>0 then
							Duel.SendtoHand(g,nil,REASON_EFFECT)
							Duel.ConfirmCards(1-tp,g)
						end
					end
		  end
   end
end





function s.aschfilter(c,e,tp,lv)
	local clv=c:GetLevel()
	return clv>0 and clv<lv and c:IsSetCard(0x8) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end

function s.schfilter(c)
	return c:IsSetCard(0x8) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end

function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	local dam=bc:GetDefense()
	if dam<0 then dam=0 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
  Duel.SetTargetCard(bc)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local lv=tc:GetOriginalLevel()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if tc and tc:IsRelateToEffect(e) then 
	if Duel.Remove(tc,0,REASON_EFFECT) then
			Duel.Damage(p,d,REASON_EFFECT)
			if Duel.IsExistingMatchingCard(s.schfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
					   -- local g=Duel.SelectMatchingCard(tp,s.schfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp,lv)
						 local g=Duel.SelectMatchingCard(tp,s.schfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
						if #g>0 then
							Duel.SendtoHand(g,nil,REASON_EFFECT)
							Duel.ConfirmCards(1-tp,g)
						end
			end
	end
	end
end

