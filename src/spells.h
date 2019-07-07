/**
 * The Forgotten Server - a free and open-source MMORPG server emulator
 * Copyright (C) 2018  Mark Samman <mark.samman@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

#ifndef FS_SPELLS_H_D78A7CCB7080406E8CAA6B1D31D3DA71
#define FS_SPELLS_H_D78A7CCB7080406E8CAA6B1D31D3DA71

#include "luascript.h"
#include "player.h"
#include "actions.h"
#include "talkaction.h"
#include "baseevents.h"

class InstantSpell;
class RuneSpell;
class Spell;

using VocSpellMap = std::map<uint16_t, bool>;

class Spells final : public BaseEvents
{
	public:
		Spells();
		~Spells();

		// non-copyable
		Spells(const Spells&) = delete;
		Spells& operator=(const Spells&) = delete;

		Spell* getSpellByName(const std::string& name);
		RuneSpell* getRuneSpell(uint32_t id);
		RuneSpell* getRuneSpellByName(const std::string& name);

		InstantSpell* getInstantSpell(const std::string& words);
		InstantSpell* getInstantSpellByName(const std::string& name);

		InstantSpell* getInstantSpellById(uint32_t spellId);

		TalkActionResult_t playerSaySpell(Player* player, std::string& words);

		static Position getCasterPosition(Creature* creature, Direction dir);
		std::string getScriptBaseName() const override;

		const std::map<std::string, InstantSpell>& getInstantSpells() const {
			return instants;
		};

	private:
		void clear() override;
		LuaScriptInterface& getScriptInterface() override;
		Event_ptr getEvent(const std::string& nodeName) override;
		bool registerEvent(Event_ptr event, const pugi::xml_node& node) override;

		std::map<uint16_t, RuneSpell> runes;
		std::map<std::string, InstantSpell> instants;

		friend class CombatSpell;
		LuaScriptInterface scriptInterface { "Spell Interface" };
};

using RuneSpellFunction = std::function<bool(const RuneSpell* spell, Player* player, const Position& posTo)>;

class BaseSpell
{
	public:
		constexpr BaseSpell() = default;
		virtual ~BaseSpell() = default;

		virtual bool castSpell(Creature* creature) = 0;
		virtual bool castSpell(Creature* creature, Creature* target) = 0;
};

class CombatSpell final : public Event, public BaseSpell
{
	public:
		CombatSpell(Combat* combat, bool needTarget, bool needDirection);
		~CombatSpell();

		// non-copyable
		CombatSpell(const CombatSpell&) = delete;
		CombatSpell& operator=(const CombatSpell&) = delete;

		bool castSpell(Creature* creature) override;
		bool castSpell(Creature* creature, Creature* target) override;
		bool configureEvent(const pugi::xml_node&) override {
			return true;
		}

		//scripting
		bool executeCastSpell(Creature* creature, const LuaVariant& var);

		bool loadScriptCombat();
		Combat* getCombat() {
			return combat;
		}

	private:
		std::string getScriptEventName() const override {
			return "onCastSpell";
		}

		Combat* combat;

		bool needDirection;
		bool needTarget;
};

class Spell : public BaseSpell
{
	public:
		Spell() = default;

		bool configureSpell(const pugi::xml_node& node);
		const std::string& getName() const {
			return name;
		}

		void postCastSpell(Player* player, bool finishedCast = true, bool payCost = true) const;
		static void postCastSpell(Player* player, uint32_t manaCost, uint32_t soulCost);

		uint32_t getManaCost(const Player* player) const;
		uint32_t getSoulCost() const {
			return soul;
		}
		uint32_t getLevel() const {
			return level;
		}
		uint32_t getMagicLevel() const {
			return magLevel;
		}
		uint32_t getMana() const {
			return mana;
		}
		uint32_t getManaPercent() const {
			return manaPercent;
		}
		bool isPremium() const {
			return premium;
		}

		virtual bool isInstant() const = 0;
		bool isLearnable() const {
			return learnable;
		}

		const VocSpellMap& getVocMap() const {
			return vocSpellMap;
		}

	protected:
		bool playerSpellCheck(Player* player) const;
		bool playerInstantSpellCheck(Player* player, const Position& toPos);
		bool playerRuneSpellCheck(Player* player, const Position& toPos);

		VocSpellMap vocSpellMap;

		uint32_t cooldown = 1000;
		uint32_t level = 0;
		uint32_t magLevel = 0;
		int32_t range = -1;
		int32_t fist = 0;
		int32_t club = 0;
		int32_t sword = 0;
		int32_t axe = 0;
		int32_t distance = 0;
		int32_t shield = 0;
		int32_t fish = 0;

		uint8_t spellId = 0;

		bool selfTarget = false;
		bool needTarget = false;

	private:

		uint32_t mana = 0;
		uint32_t manaPercent = 0;
		uint32_t soul = 0;

		bool needWeapon = false;
		bool blockingSolid = false;
		bool blockingCreature = false;
		bool aggressive = true;
		bool learnable = false;
		bool enabled = true;
		bool premium = false;


	private:
		std::string name;
};

class InstantSpell final : public TalkAction, public Spell
{
	public:
		explicit InstantSpell(LuaScriptInterface* interface) : TalkAction(interface) {}

		bool configureEvent(const pugi::xml_node& node) override;

		virtual bool playerCastInstant(Player* player, std::string& param);

		bool castSpell(Creature* creature) override;
		bool castSpell(Creature* creature, Creature* target) override;

		//scripting
		bool executeCastSpell(Creature* creature, const LuaVariant& var);

		bool isInstant() const override {
			return true;
		}
		bool getHasParam() const {
			return hasParam;
		}
		bool getHasPlayerNameParam() const {
			return hasPlayerNameParam;
		}
		bool canCast(const Player* player) const;
		bool canThrowSpell(const Creature* creature, const Creature* target) const;

	private:
		std::string getScriptEventName() const override;

		bool internalCastSpell(Creature* creature, const LuaVariant& var);

		bool needDirection = false;
		bool hasParam = false;
		bool hasPlayerNameParam = false;
		bool checkLineOfSight = true;
		bool casterTargetOrDirection = false;
};

class RuneSpell final : public Action, public Spell
{
	public:
		explicit RuneSpell(LuaScriptInterface* interface) : Action(interface) {}

		bool configureEvent(const pugi::xml_node& node) override;

		ReturnValue canExecuteAction(const Player* player, const Position& toPos) override;
		bool hasOwnErrorHandler() override {
			return true;
		}
		Thing* getTarget(Player*, Creature* targetCreature, const Position&, uint8_t) const override {
			return targetCreature;
		}

		bool executeUse(Player* player, Item* item, const Position& fromPosition, Thing* target, const Position& toPosition, bool isHotkey) override;

		bool castSpell(Creature* creature) override;
		bool castSpell(Creature* creature, Creature* target) override;

		//scripting
		bool executeCastSpell(Creature* creature, const LuaVariant& var, bool isHotkey);

		bool isInstant() const override {
			return false;
		}
		uint16_t getRuneItemId() const {
			return runeId;
		}

	private:
		std::string getScriptEventName() const override;

		bool internalCastSpell(Creature* creature, const LuaVariant& var, bool isHotkey);

		uint16_t runeId = 0;
		bool hasCharges = true;
};

#endif
