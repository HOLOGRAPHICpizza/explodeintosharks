SWEP.Author			= "HOLOGRAPHICpizza, TH89, SilverRaptor"
SWEP.Contact		= "mcraft@peak15.org"
SWEP.Purpose		= "Makes things explode into sharks!"
SWEP.Instructions	= "Left click to make things explode into sharks!"
SWEP.Category		= "Explode Into Sharks"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.PrintName			= "Explode into sharks!"			
SWEP.Slot				= 2
SWEP.SlotPos			= 0
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= true
SWEP.ViewModel			= "models/weapons/v_pistol.mdl"
SWEP.WorldModel			= "models/weapons/w_pistol.mdl"

function SWEP:Initialize()
	print("LOADING FRIGGIN SHARKS!!!")
	
	self:SetWeaponHoldType("smg")
end

function SWEP:Reload()
end

function SWEP:PrimaryAttack()
	if CLIENT then return end
	
	self.Weapon:SetNextPrimaryFire(CurTime() + 0.5)
	
	local trace = self.Owner:GetEyeTrace()
	
	if trace.HitWorld or not trace.Entity:IsValid() then
		self.Owner:EmitSound(Sound("weapons/pistol/pistol_empty.wav"))
		return
	end
	
	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.Owner:EmitSound(Sound("weapons/pistol/pistol_fire" .. math.random(2,3) .. ".wav"))
	
	if trace.Entity:IsPlayer() then
		trace.Entity:KillSilent()
	else
		trace.Entity:Remove()
	end
	
	for i=1, math.random(2,10), 1 do
		local shark = ents.Create("prop_ragdoll")
		shark:SetModel("models/th89/Blue_Shark/blue_shark.mdl")
		shark:SetPos( trace.HitPos )
		shark:SetOwner( self.Owner )
		shark:Spawn()
		shark:Activate()
		shark.PhysgunPickup = function() return true end
		shark.CanTool = function() return true end
		
		shark:GetPhysicsObject():ApplyForceCenter( Vector( math.random(-100000,100000), math.random(-100000,100000), 100000 ) )
		
		undo.Create("Ragdoll")
		undo.AddEntity(shark)
		undo.SetPlayer(self.Owner)
		undo.Finish()
	end
	
	local explode = ents.Create( "env_explosion" )
	explode:SetPos( trace.HitPos )
	explode:SetOwner( self.Owner )
	explode:Spawn()
	explode:SetKeyValue( "iMagnitude", "50" )
	explode:Fire( "Explode", 0, 0 )
	explode:EmitSound( "weapon_AWP.Single", 400, 400 )
	
end

function SWEP:SecondaryAttack()
end

function SWEP:Deploy()
end

function SWEP:Holster()
	return true
end