// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

struct Accessory {
    uint64 UID;
    uint64 Strength;
}

struct Hero {
    uint64 UID;
    // Vector-based inventory
    Accessory[] Inventory;
}

contract DynArrayHero {

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
        for(uint64 i = 0; i < 200; i++) {
            hero.Inventory.push(Accessory(i,0));
        }
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
        for(uint64 i = 0; i < 200; i++) {
            hero.Inventory[i].Strength++;
        }
    }

    // Why only 250 times?
    // Because when I tried updating it 1000 times, I crashed Remix.
    // I suspect there is a clear loser between DynArrayHero and MappingHero
    function updateHero250Times(uint64 heroID) public {
        for(uint i = 0; i < 250; i++ ) {
            updateHeroOnce(heroID);
        }
    }

    // Access One Hero times
    function accessHeroOnce(uint64 heroID) public view {
        Hero storage hero = Lineup[msg.sender][heroID];

        // Variable to access accesory strengths
        uint64 tempAccessoryStrength;

        // Access each of the hero's accessories
        for(uint64 i = 0; i < 200; i++) {
            tempAccessoryStrength = hero.Inventory[i].Strength;
        }
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
        for(uint64 i = 0; i < 200; i++) {
            delete(hero.Inventory[i]);
        }

        // Delete empty vector
        delete hero.Inventory;

        // Delete the Hero object itself
        delete Lineup[msg.sender][heroID];
    }
}