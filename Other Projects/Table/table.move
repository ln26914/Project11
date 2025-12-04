module table_vs_object_table::table{

    use sui::table;
    use sui::dynamic_field;
    use sui::dynamic_object_field;

    // To be used in Dynamic and Dynamic Object Fields
    public struct Hero has key, store{
        id: UID
    }
    
    // To be used in Wrapped Hero
    public struct Wrapped_Hero has key, store{
        id: UID,
        inventory: sui::table::Table<u64, Accessory>
    }

    // using a single accessory type
    public struct Accessory has key, store{
        id: UID,
        strength: u64
    }
    
    
    public entry fun create_single_table_dynamicField(ctx: &mut TxContext){

        // creating Hero object & table
        let mut hero = Hero{id: object::new(ctx)};
        let mut table = table::new<u64, Accessory>(ctx);

        // creating sword, shield, and hat
        // table can only take one datatype unlike bag, thus we use Accessory type
        let sword = Accessory{id: object::new(ctx), strength: 0};
        let shield = Accessory{id: object::new(ctx), strength: 0};
        let hat = Accessory{id: object::new(ctx), strength: 0};

        // adding sword, shield, and hat into the table
        table::add(&mut table, 0, sword);
        table::add(&mut table, 1, shield);
        table::add(&mut table, 2, hat);

        // adding table to Hero as Dynamic Field
        dynamic_field::add(&mut hero.id, b"inventory", table);

        // transferring ownership of the hero to ourselves
        transfer::transfer(hero, tx_context::sender(ctx));

        

        /* NO LONGER NEEDED
        // transferring ownership of the table to ourselves (we should actually give onwership to hero)
        sui::transfer::public_transfer(table, tx_context::sender(ctx));
        */
    }


    public entry fun create_table_dynamicField(ctx: &mut TxContext){
        let mut i = 0;

        while(i < 125){
            // creating Hero object & table
            let mut hero = Hero{id: object::new(ctx)};
            let mut table = table::new<u64, Accessory>(ctx);

            // creating sword, shield, and hat
            // table can only take one datatype unlike bag, thus we use Accessory type
            let sword = Accessory{id: object::new(ctx), strength: 0};
            let shield = Accessory{id: object::new(ctx), strength: 0};
            let hat = Accessory{id: object::new(ctx), strength: 0};

            // adding sword, shield, and hat into the table
            table::add(&mut table, 0, sword);
            table::add(&mut table, 1, shield);
            table::add(&mut table, 2, hat);

            // adding table to Hero as Dynamic Field
            dynamic_field::add(&mut hero.id, b"inventory", table);

            // transferring ownership of the hero to ourselves
            transfer::transfer(hero, tx_context::sender(ctx));
            i = i + 1;
        }
    }



    public entry fun create_table_dynamicObjectField(ctx: &mut TxContext){
        let mut i = 0;

        while(i < 125){
            // creating Hero object & table
            let mut hero = Hero{id: object::new(ctx)};
            let mut table = table::new<u64, Accessory>(ctx);

            // creating sword, shield, and hat
            // table can only take one datatype unlike bag, thus we use Accessory type
            let sword = Accessory{id: object::new(ctx), strength: 0};
            let shield = Accessory{id: object::new(ctx), strength: 0};
            let hat = Accessory{id: object::new(ctx), strength: 0};

            // adding sword, shield, and hat into the table
            table::add(&mut table, 0, sword);
            table::add(&mut table, 1, shield);
            table::add(&mut table, 2, hat);

            // adding table to Hero as Dynamic Object Field
            dynamic_object_field::add(&mut hero.id, b"inventory", table);

            // transferring ownership of the hero to ourselves
            transfer::transfer(hero, tx_context::sender(ctx));
            i = i + 1;
        }
    }

    public entry fun create_single_table_Wrapped(ctx: &mut TxContext){
        
        let mut table = table::new<u64, Accessory>(ctx);

        let sword = Accessory{id: object::new(ctx), strength: 0};
        let shield = Accessory{id: object::new(ctx), strength: 0};
        let hat = Accessory{id: object::new(ctx), strength: 0};

        table::add(&mut table, 0, sword);
        table::add(&mut table, 1, shield);
        table::add(&mut table, 2, hat);

        let hero = Wrapped_Hero{id: object::new(ctx), inventory: table};

        transfer::transfer(hero, tx_context::sender(ctx));

    }

    public entry fun create_table_Wrapped(ctx: &mut TxContext){
        let mut i = 0;

        while( i < 125){
            let mut table = table::new<u64, Accessory>(ctx);

            let sword = Accessory{id: object::new(ctx), strength: 0};
            let shield = Accessory{id: object::new(ctx), strength: 0};
            let hat = Accessory{id: object::new(ctx), strength: 0};

            table::add(&mut table, 0, sword);
            table::add(&mut table, 1, shield);
            table::add(&mut table, 2, hat);

            let hero = Wrapped_Hero{id: object::new(ctx), inventory: table};

            transfer::transfer(hero, tx_context::sender(ctx));

            i = i + 1;
        }
    }


    

    public entry fun access_table_dynamicField(hero: &mut Hero){
        let mut i = 0;
        let mut access_strength = 0u64;

        // creating reference to table to borrow Accessories from the Dynamic Field
        let mut table_ref: &mut sui::table::Table<u64, Accessory> = dynamic_field::borrow_mut(&mut hero.id, b"inventory");

        // borrowing sword, shield, and hat Accessories from table
        let mut sword = table::borrow(table_ref, 0);
        let mut shield = table::borrow(table_ref, 1);
        let mut hat = table::borrow(table_ref, 2);

        while(i < 10000){
            // creating reference to table
            table_ref = dynamic_field::borrow_mut(&mut hero.id, b"inventory");

            // borrowing sword, shield, and hat Accessories from table
            sword = table::borrow(table_ref, 0);
            shield = table::borrow(table_ref, 1);
            hat = table::borrow(table_ref, 2);

            access_strength = sword.strength;
            access_strength = shield.strength;
            access_strength = hat.strength;

            i = i + 1;
        }
    }


    // Accessing the Accessory's strength from the Table
    public entry fun access_table_dynamicObjectField(hero: &mut Hero){
        let mut i = 0;
        let mut access_strength = 0u64;

        // creating reference to table to borrow Accessories from the Dynamic Object Field
        let mut table_ref: &mut sui::table::Table<u64, Accessory> = dynamic_object_field::borrow_mut(&mut hero.id, b"inventory");

        // borrowing sword, shield, and hat Accessories from table
        let mut sword = table::borrow(table_ref, 0);
        let mut shield = table::borrow(table_ref, 1);
        let mut hat = table::borrow(table_ref, 2);

        while(i < 10000){
            // creating reference to table
            table_ref = dynamic_object_field::borrow_mut(&mut hero.id, b"inventory");

            // borrowing sword, shield, and hat Accessories from table
            sword = table::borrow(table_ref, 0);
            shield = table::borrow(table_ref, 1);
            hat = table::borrow(table_ref, 2);

            access_strength = sword.strength;
            access_strength = shield.strength;
            access_strength = hat.strength;

            i = i + 1;
        }
    }


    public entry fun access_table_wrappedHero(hero: &mut Wrapped_Hero){
        let mut i = 0;
        let mut access_strength = 0u64;

        let mut sword = table::borrow(&mut hero.inventory, 0);
        let mut shield = table::borrow(&mut hero.inventory, 1);
        let mut hat = table::borrow(&mut hero.inventory, 2);

        while(i < 10000){
            sword = table::borrow(&mut hero.inventory, 0);
            shield = table::borrow(&mut hero.inventory, 1);
            hat = table::borrow(&mut hero.inventory, 2);


            access_strength = sword.strength;
            access_strength = shield.strength;
            access_strength = hat.strength;

            i = i + 1;
        }
    }

    public entry fun update_table_wrappedHero(hero: &mut Wrapped_Hero){
        let mut i = 0;
        //let mut update_strength = 0u64;
        
        let mut sword = table::borrow_mut(&mut hero.inventory, 0);
        sword.strength = sword.strength + 1;

        let mut shield = table::borrow_mut(&mut hero.inventory, 1);
        shield.strength = shield.strength + 1;

        let mut hat = table::borrow_mut(&mut hero.inventory, 2);
        hat.strength = hat.strength + 1;


        while (i < 10000){
            sword = table::borrow_mut(&mut hero.inventory, 0);
            sword.strength = sword.strength + 1;

            shield = table::borrow_mut(&mut hero.inventory, 1);
            shield.strength = shield.strength + 1;

            hat = table::borrow_mut(&mut hero.inventory, 2);
            hat.strength = hat.strength + 1;

            i = i + 1;
        }
    }


    public entry fun update_table_dynamicField(hero: &mut Hero){
        let mut i = 0;
        let mut update_strength = 0u64;

        // creating reference to table to borrow Accessories from the Dynamic Field
        let mut table_ref: &mut sui::table::Table<u64, Accessory> = dynamic_field::borrow_mut(&mut hero.id, b"inventory");

        // borrowing sword, shield, and hat Accessories from table
        let mut sword = table::borrow_mut(table_ref, 0);
        sword.strength = sword.strength + 1;

        let mut shield = table::borrow_mut(table_ref, 1);
        shield.strength = shield.strength + 1;
        
        let mut hat = table::borrow_mut(table_ref, 2);
        hat.strength = hat.strength + 1;

        //sword.strength = sword.strength + 1;
        //shield.strength = shield.strength + 1;
        //hat.strength = hat.strength + 1;


        while(i < 10000){
            // creating reference to table
            table_ref = dynamic_field::borrow_mut(&mut hero.id, b"inventory");

            // borrowing and updating sword, shield, and hat Accessories from table
            sword = table::borrow_mut(table_ref, 0);
            sword.strength = sword.strength + 1;

            shield = table::borrow_mut(table_ref, 1);
            shield.strength = shield.strength + 1;

            hat = table::borrow_mut(table_ref, 2);
            hat.strength = hat.strength + 1;

            

            i = i + 1;
        }
    }


    public entry fun update_table_dynamicObjectField(hero: &mut Hero){
        let mut i = 0;
        let mut update_strength = 0u64;

        // creating reference to table to borrow Accessories from the Dynamic Field
        let mut table_ref: &mut sui::table::Table<u64, Accessory> = dynamic_object_field::borrow_mut(&mut hero.id, b"inventory");

        // borrowing sword, shield, and hat Accessories from table
        let mut sword = table::borrow_mut(table_ref, 0);
        sword.strength = sword.strength + 1;

        let mut shield = table::borrow_mut(table_ref, 1);
        shield.strength = shield.strength + 1;
        
        let mut hat = table::borrow_mut(table_ref, 2);
        hat.strength = hat.strength + 1;

        //sword.strength = sword.strength + 1;
        //shield.strength = shield.strength + 1;
        //hat.strength = hat.strength + 1;


        while(i < 10000){
            // creating reference to table
            table_ref = dynamic_object_field::borrow_mut(&mut hero.id, b"inventory");

            // borrowing and updating sword, shield, and hat Accessories from table
            sword = table::borrow_mut(table_ref, 0);
            sword.strength = sword.strength + 1;

            shield = table::borrow_mut(table_ref, 1);
            shield.strength = shield.strength + 1;

            hat = table::borrow_mut(table_ref, 2);
            hat.strength = hat.strength + 1;

            i = i + 1;
        }
    }

    


    // ***************************************************************************************************

    // unpacking and deleting Accessories
    public fun delete_sword(table_ref: &mut sui::table::Table<u64, Accessory>){
        // Unpack Accessory
        let Accessory{id, strength:_} = table::remove(table_ref, 0);
        // Deleting Accessory
        object::delete(id);
    }

    public fun delete_shield(table_ref: &mut sui::table::Table<u64, Accessory>){
        // Unpack Accessory
        let Accessory{id, strength:_} = table::remove(table_ref, 1);
        // Deleting Accessory
        object::delete(id);
    }

    public fun delete_hat(table_ref: &mut sui::table::Table<u64, Accessory>){
        // Unpack Accessory
        let Accessory{id, strength:_} = table::remove(table_ref, 2);
        // Deleting Accessory
        object::delete(id);
    }
    
    public fun delete_table_contents_DF(hero: &mut Hero){
        let mut table_ref = dynamic_field::borrow_mut(&mut hero.id, b"inventory");

        delete_sword(table_ref);
        delete_shield(table_ref);
        delete_hat(table_ref);
    }

    public fun delete_table_contents_DOF(hero: &mut Hero){
        let mut table_ref = dynamic_object_field::borrow_mut(&mut hero.id, b"inventory");

        delete_sword(table_ref);
        delete_shield(table_ref);
        delete_hat(table_ref);
    }

    public fun delete_table_contents_wrapped(hero: &mut Wrapped_Hero){
        let mut table_ref = &mut hero.inventory;

        delete_sword(table_ref);
        delete_shield(table_ref);
        delete_hat(table_ref);
    }

    // Deleting Tables
    public entry fun delete_table_dynamicField_detachAndDeleteAccessories(mut hero: Hero){
        delete_table_contents_DF(&mut hero);

        let table_ref: table::Table<u64, Accessory> = dynamic_field::remove(&mut hero.id, b"inventory");
        table::destroy_empty(table_ref);
        
        let Hero{id} = hero;

        object::delete(id);
    }

    



    // Deleting Object Tables
    public entry fun delete_table_dynamicObjectField_detachAndDeleteAccessories(mut hero: Hero){
        delete_table_contents_DOF(&mut hero);

        let table_ref: table::Table<u64, Accessory> = dynamic_object_field::remove(&mut hero.id, b"inventory");
        table::destroy_empty(table_ref);
        
        let Hero{id} = hero;

        object::delete(id);
    }
    
    // Deleting Wrapped Tables
    public entry fun delete_wrapped_table_UnpackAndDeleteHeroAndAccessories(mut hero: Wrapped_Hero){
        delete_table_contents_wrapped(&mut hero);

        let Wrapped_Hero{id, inventory} = hero;
        object::delete(id);

        table::destroy_empty(inventory);
    }

}
