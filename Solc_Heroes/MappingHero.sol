// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

struct Accessory {
    uint64 UID;
    uint64 Strength;
}

struct Hero {
    uint64 UID;
    //       UID       ACC
    mapping(uint64 => Accessory) Inventory; // Maps the UID of an accessory to the accessory itself
}

contract MappingHero {

    // Mapping to associate Hero Objects with accounts
    //       ACCT               IDX        OBJ
    mapping(address => mapping(uint64 => Hero)) public Lineup;
    mapping (address => uint64) public heroCount;

    // Create One Hero
    function createOneHero() public {

        // Create ID for new hero, and increase HeroCount
        uint64 id = heroCount[msg.sender];
        heroCount[msg.sender]++;

        Hero storage hero = Lineup[msg.sender][id];
        hero.UID = id;

        // Create Accessories and add to hero
        hero.Inventory[0] = Accessory(0,0);
        hero.Inventory[1] = Accessory(1,0);
        hero.Inventory[2] = Accessory(2,0);
    }

    // Create Ten Heroes
    function createTenHeroes() public {
        for(uint i = 0; i < 10; i++ ) {
            createOneHero();
        }
    }
    
    // Update One Hero 250 times
    function updateHeroOnce(uint64 heroID) public {

        Hero storage hero = Lineup[msg.sender][heroID];

        // Update each accessory
        hero.Inventory[0].Strength++;
        hero.Inventory[1].Strength++;
        hero.Inventory[2].Strength++;
    }

    function updateHero250Times(uint64 heroID) public {
        for(uint i = 0; i < 1; i++ ) {
            updateHeroOnce(heroID);
        }
    }

    // Access One Hero times
    function accessHeroOnce(uint64 heroID) public view {
        Hero storage hero = Lineup[msg.sender][heroID];

        uint64 swordStrength;
        uint64 shieldStrength;
        uint64 hatStrength;

        swordStrength = hero.Inventory[0].Strength;
        shieldStrength = hero.Inventory[1].Strength;
        hatStrength = hero.Inventory[2].Strength;
    }
    function accessHero1000Times(uint64 heroID) public view {
        for(uint i = 0; i < 1000; i++) {
            accessHeroOnce(heroID);
        }
    }

    // Delete One Hero
    function deleteOneHero(uint64 heroID) public {

        Hero storage hero = Lineup[msg.sender][heroID];

        // Delete the Hero's accessories
        delete hero.Inventory[0];
        delete hero.Inventory[1];
        delete hero.Inventory[2];

        // Delete the Hero object itself
        delete Lineup[msg.sender][heroID];
    }
}