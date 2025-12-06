module table_vs_object_table::vector_inventory{

    use sui::dynamic_field;
    use sui::dynamic_object_field;
    use sui::tx_context::{self, TxContext};
    use sui::vector;
    use sui::object;
    use sui::transfer;
    use sui::uid::UID;

    // To be used in Dynamic and Dynamic Object Fields
    public struct Hero has key, store{
        id: UID
    }
    
    // To be used in Wrapped Hero
    public struct Wrapped_Hero has key, store{
        id: UID,
        inventory: vector<Accessory>
    }

    // using a single accessory type
    public struct Accessory has store, drop{
        strength: u64
    }

    // New Functions
    public entry fun create_ten_heroes_with_vectors(ctx: &mut TxContext){
        let mut i = 0;

        // Create 10 heroes
        while(i < 10){
            // Create one hero with vector
            create_single_vector_dynamicField(ctx);
            i = i + 1;
        }
    }

    public entry fun update_hero(ctx: &mut TxContext, hero: &mut Hero) {
        update_vector_dynamicField(hero);
    }

    public entry fun access_hero(ctx: &mut TxContext, hero: &mut Hero) {
        access_vector_dynamicField(hero);
    }

     public entry fun delete_one_hero(ctx: &mut TxContext, mut hero: Hero){
        // Remove the inventory dynamic field
        let _inventory: vector<Accessory> = dynamic_field::remove(&mut hero.id, b"inventory");
        // Vector will be automatically dropped
        
        // With the inventory deleted, delete the hero object itself
        let Hero {id} = hero;
        object::delete(id);
    }
    
    // Existing source code functions modified for vectors
    public entry fun create_single_vector_dynamicField(ctx: &mut TxContext){

        // creating Hero object & vector
        let mut hero = Hero{id: object::new(ctx)};
        let mut inventory = vector::empty<Accessory>();

        // creating 200 accessories
        let mut i = 0;
        while(i < 200){
            let accessory = Accessory{strength: 0};
            vector::push_back(&mut inventory, accessory);
            i = i + 1;
        };

        // adding vector to Hero as Dynamic Field
        dynamic_field::add(&mut hero.id, b"inventory", inventory);

        // transferring ownership of the hero to ourselves
        transfer::transfer(hero, tx_context::sender(ctx));
    }


    public entry fun create_vector_dynamicField(ctx: &mut TxContext){
        let mut i = 0;

        while(i < 125){
            // creating Hero object & vector
            let mut hero = Hero{id: object::new(ctx)};
            let mut inventory = vector::empty<Accessory>();

            // creating 200 accessories
            let mut j = 0;
            while(j < 200){
                let accessory = Accessory{strength: 0};
                vector::push_back(&mut inventory, accessory);
                j = j + 1;
            };

            // adding vector to Hero as Dynamic Field
            dynamic_field::add(&mut hero.id, b"inventory", inventory);

            // transferring ownership of the hero to ourselves
            transfer::transfer(hero, tx_context::sender(ctx));
            i = i + 1;
        }
    }



    public entry fun create_vector_dynamicObjectField(ctx: &mut TxContext){
        let mut i = 0;

        while(i < 125){
            // creating Hero object & vector
            let mut hero = Hero{id: object::new(ctx)};
            let mut inventory = vector::empty<Accessory>();

            // creating 200 accessories
            let mut j = 0;
            while(j < 200){
                let accessory = Accessory{strength: 0};
                vector::push_back(&mut inventory, accessory);
                j = j + 1;
            };

            // adding vector to Hero as Dynamic Object Field
            dynamic_object_field::add(&mut hero.id, b"inventory", inventory);

            // transferring ownership of the hero to ourselves
            transfer::transfer(hero, tx_context::sender(ctx));
            i = i + 1;
        }
    }

    public entry fun create_single_vector_Wrapped(ctx: &mut TxContext){
        
        let mut inventory = vector::empty<Accessory>();

        // creating 200 accessories
        let mut i = 0;
        while(i < 200){
            let accessory = Accessory{strength: 0};
            vector::push_back(&mut inventory, accessory);
            i = i + 1;
        };

        let hero = Wrapped_Hero{id: object::new(ctx), inventory};

        transfer::transfer(hero, tx_context::sender(ctx));

    }

    public entry fun create_vector_Wrapped(ctx: &mut TxContext){
        let mut i = 0;

        while( i < 125){
            let mut inventory = vector::empty<Accessory>();

            // creating 200 accessories
            let mut j = 0;
            while(j < 200){
                let accessory = Accessory{strength: 0};
                vector::push_back(&mut inventory, accessory);
                j = j + 1;
            };

            let hero = Wrapped_Hero{id: object::new(ctx), inventory};

            transfer::transfer(hero, tx_context::sender(ctx));

            i = i + 1;
        }
    }


    

    public entry fun access_vector_dynamicField(hero: &mut Hero){
        let mut i = 0;
        let mut access_strength = 0u64;

        // creating reference to vector to borrow Accessories from the Dynamic Field
        let inventory_ref: &vector<Accessory> = dynamic_field::borrow(&hero.id, b"inventory");

        while(i < 1000){
            // creating reference to vector
            inventory_ref = dynamic_field::borrow(&hero.id, b"inventory");

            // accessing accessories from vector
            let mut j = 0;
            while(j < 200){
                let accessory = vector::borrow(inventory_ref, j);
                access_strength = accessory.strength;
                j = j + 1;
            };

            i = i + 1;
        }
    }


    // Accessing the Accessory's strength from the Vector
    public entry fun access_vector_dynamicObjectField(hero: &mut Hero){
        let mut i = 0;
        let mut access_strength = 0u64;

        // creating reference to vector to borrow Accessories from the Dynamic Object Field
        let inventory_ref: &vector<Accessory> = dynamic_object_field::borrow(&hero.id, b"inventory");

        while(i < 10000){
            // creating reference to vector
            inventory_ref = dynamic_object_field::borrow(&hero.id, b"inventory");

            // accessing accessories from vector
            let mut j = 0;
            while(j < 200){
                let accessory = vector::borrow(inventory_ref, j);
                access_strength = accessory.strength;
                j = j + 1;
            };

            i = i + 1;
        }
    }


    public entry fun access_vector_wrappedHero(hero: &mut Wrapped_Hero){
        let mut i = 0;
        let mut access_strength = 0u64;

        while(i < 1000){
            // accessing accessories from vector
            let mut j = 0;
            while(j < 200){
                let accessory = vector::borrow(&hero.inventory, j);
                access_strength = accessory.strength;
                j = j + 1;
            };

            i = i + 1;
        }
    }

    public entry fun update_vector_wrappedHero(hero: &mut Wrapped_Hero){
        let mut i = 0;

        while (i < 1000){
            // updating accessories in vector
            let mut j = 0;
            while(j < 200){
                let accessory = vector::borrow_mut(&mut hero.inventory, j);
                accessory.strength = accessory.strength + 1;
                j = j + 1;
            };

            i = i + 1;
        }
    }


    public entry fun update_vector_dynamicField(hero: &mut Hero){
        let mut i = 0;
        let mut update_strength = 0u64;

        // creating reference to vector to borrow Accessories from the Dynamic Field
        let mut inventory_ref: &mut vector<Accessory> = dynamic_field::borrow_mut(&mut hero.id, b"inventory");

        while(i < 1000){
            // creating reference to vector
            inventory_ref = dynamic_field::borrow_mut(&mut hero.id, b"inventory");

            // updating accessories in vector
            let mut j = 0;
            while(j < 200){
                let accessory = vector::borrow_mut(inventory_ref, j);
                accessory.strength = accessory.strength + 1;
                j = j + 1;
            };

            i = i + 1;
        }
    }


    public entry fun update_vector_dynamicObjectField(hero: &mut Hero){
        let mut i = 0;
        let mut update_strength = 0u64;

        // creating reference to vector to borrow Accessories from the Dynamic Field
        let mut inventory_ref: &mut vector<Accessory> = dynamic_object_field::borrow_mut(&mut hero.id, b"inventory");

        while(i < 1000){
            // creating reference to vector
            inventory_ref = dynamic_object_field::borrow_mut(&mut hero.id, b"inventory");

            // updating accessories in vector
            let mut j = 0;
            while(j < 200){
                let accessory = vector::borrow_mut(inventory_ref, j);
                accessory.strength = accessory.strength + 1;
                j = j + 1;
            };

            i = i + 1;
        }
    }

    // Deleting Vector-based inventories
    public entry fun delete_vector_dynamicField(mut hero: Hero){
        let _inventory: vector<Accessory> = dynamic_field::remove(&mut hero.id, b"inventory");
        // Vector will be automatically dropped
        
        let Hero{id} = hero;
        object::delete(id);
    }

    public entry fun delete_vector_dynamicObjectField(mut hero: Hero){
        let _inventory: vector<Accessory> = dynamic_object_field::remove(&mut hero.id, b"inventory");
        // Vector will be automatically dropped
        
        let Hero{id} = hero;
        object::delete(id);
    }
    
    // Deleting Wrapped Vector
    public entry fun delete_wrapped_vector(mut hero: Wrapped_Hero){
        let Wrapped_Hero{id, inventory: _} = hero;
        object::delete(id);
        // Vector will be automatically dropped
    }


}