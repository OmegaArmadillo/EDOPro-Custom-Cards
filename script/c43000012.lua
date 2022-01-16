--Elemental HERO Nova Wingman
local s,id=GetID()
function s.initial_effect(c)
   --Fusion Procedure
	Fusion.AddProcMixN(c,true,true,s.ffilter,2) 

	--gain atk
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.tgcon)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)

	--destroy
	local e2=Effect.CreateEffect(c)
   -- e3:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(id)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)


	local e3=Effect.CreateEffect(c)
   --e4:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(id)
	e3:SetCondition(s.bdescon)
	e3:SetTarget(s.cdestg)
	e3:SetOperation(s.cdesop)
	e3:SetLabel(4)
	c:RegisterEffect(e3)




	--destroy by effect
	local e4=Effect.CreateEffect(c)
   --e4:SetDescription(aux.Stringid(id,1))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(id)
	e4:SetCondition(s.edescon)
	e4:SetTarget(s.cdestg)
	e4:SetOperation(s.cdesop)
	e4:SetLabel(4)
	c:RegisterEffect(e4)



end

--fusion material
function s.ffilter(c,fc,sumtype,tp,sub,mg,sg)
	return c:IsSetCard(0x8,fc,sumtype,tp) and c:GetAttribute(fc,sumtype,tp)~=0 and (not sg or not sg:IsExists(s.fusfilter,1,c,c:GetAttribute(fc,sumtype,tp),fc,sumtype,tp))
end

function s.fusfilter(c,attr,fc,sumtype,tp)
	return c:IsAttribute(attr,fc,sumtype,tp) and not c:IsHasEffect(511002961)
end

--s.material_setcode={0x8,0x3008}

--attack boost
function s.tgcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end


function s.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x8)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil) end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end





--destroy effect
function s.tfilter(c,atk)
	return c:IsFaceup() and c:GetAttack()<atk
end

function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and s.tfilter(chkc,e:GetHandler():GetAttack()) end
	if chk==0 then return Duel.IsExistingTarget(s.tfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e:GetHandler():GetAttack()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,s.tfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e:GetHandler():GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc and tc:IsFaceup() and tc:IsRelateToEffect(e)
		and tc:GetBaseAttack()<c:GetAttack() then
		Duel.Destroy(tc,REASON_EFFECT)
	end

	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(3207)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end




--choose effect when destroyed
function s.edescon(e,tp,eg,ep,ev,re,r,rp)
	return (r&REASON_EFFECT)~=0 and re:GetHandler()==e:GetHandler()
end


function s.bdescon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsRelateToBattle()
end


function s.serfilter(c)
	return ((c:IsSetCard(0x8) and c:IsType(TYPE_MONSTER)) or c:IsCode(27847700,24094653)) and c:IsAbleToHand()
end

function s.sumfilter(c)
	return c:IsSetCard(0x8) and c:IsType(TYPE_MONSTER) and c:IsLevelBelow(4) and c:IsAbleToHand()
end



function s.cdestg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		--local ct=Duel.GetMatchingGroupCount(s.ctfilter,tp,LOCATION_MZONE,0,c)
		local sel=0
		if  Duel.IsExistingMatchingCard(s.serfilter,tp,LOCATION_DECK,0,1,1,nil) then sel=sel+1 end
		if Duel.IsExistingMatchingCard(s.sumfilter,tp,LOCATION_HAND,0,1,nil) then sel=sel+2 end
		e:SetLabel(sel)
		return sel~=0
	end
	local sel=e:GetLabel()
	if sel==3 then
		--Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,0))
		sel=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1))+1
	elseif sel==1 then
		Duel.SelectOption(tp,aux.Stringid(id,0))
	else
		Duel.SelectOption(tp,aux.Stringid(id,1))
	end
	e:SetLabel(sel)
	if sel==1 then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_MZONE)
	else
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	end
end
function s.cdesop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sel=e:GetLabel()
	if sel==1 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.serfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		end
	else
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.sumfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	local tc=g:GetFirst()   
 
		if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
			--Cannot activate its effects this turn
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(3302)
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_TRIGGER)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
		end

	Duel.SpecialSummonComplete()
	end
end