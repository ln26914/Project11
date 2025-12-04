module move_gas_optimization::A_hero_with_bag_as_dynamic_field{
    use sui::dynamic_field;
    use sui::dynamic_object_field;
    use sui::bag;
    use sui::object_bag;

    // Set up Hero object structure
    public struct Hero has key, store{
        id: UID
    }

    // Set up individual accessories:
    public struct Sword has key, store{
        id: UID,
        strength: u64
    }

    public struct Shield has key, store{
        id: UID,
        strength: u64
    }

    public struct Hat has key, store{
        id: UID,
        strength: u64
    }

    // Built from Fernando's code, used for comparison
    // Iterates many times.
    // Each iteration: Creates Hero, and adds 3 accessories as seperate dynamic fields
    public entry fun create_heroes_no_bag_dynamic_fields(ctx: &mut TxContext){
        let mut i = 0;
        while (i < 125){
        
            let mut hero = Hero{id: object::new(ctx)};

            let mut sword = Sword{id: object::new(ctx), strength: 0};
            let mut shield = Shield{id: object::new(ctx), strength: 0};
            let mut hat = Hat{id: object::new(ctx), strength: 0};

            dynamic_field::add(&mut hero.id, b"sword", sword);
            dynamic_field::add(&mut hero.id, b"shield", shield);
            dynamic_field::add(&mut hero.id, b"hat", hat);

            transfer::transfer(hero, tx_context::sender(ctx));
            i = i + 1;
        }
    }
    
    // Create a single hero, create and add 3 accessories to a bag, add bag to hero as a dynamic field
    public entry fun create_hero_with_bag_in_dynamic_field(ctx: &mut TxContext){
        let mut hero = Hero{id: object::new(ctx)};

        // creating bag
        let mut bag_object = bag::new(ctx);

        
        // creating hero attributes
        let mut sword = Sword{id: object::new(ctx), strength: 0};
        let mut shield = Shield{id: object::new(ctx), strength: 0};
        let mut hat = Hat{id: object::new(ctx), strength: 0};
        
        // adding hero attributes to bag
        bag::add(&mut bag_object, 0, sword);
        bag::add(&mut bag_object, 1, shield);
        bag::add(&mut bag_object, 2, hat);

        // adding bag as dynamic fields
        dynamic_field::add(&mut hero.id, b"bag", bag_object);
        transfer::transfer(hero, tx_context::sender(ctx));
    }

    // Create many hero objects. 
    // In each iteration, creates hero object, create and add 3 accessories to a bag, add bag to hero as a dynamic field
    public entry fun create_heroes_with_bag_in_dynamic_field(ctx: &mut TxContext){
        let mut i = 0;
        while (i < 125){
            // Create Hero object
            let mut hero = Hero{id: object::new(ctx)};

            // creating bag
            let mut bag_object = bag::new(ctx);

            
            // creating hero attributes
            let mut sword = Sword{id: object::new(ctx), strength: 0};
            let mut shield = Shield{id: object::new(ctx), strength: 0};
            let mut hat = Hat{id: object::new(ctx), strength: 0};
            
            // adding hero attributes to bag
            bag::add(&mut bag_object, 0, sword);
            bag::add(&mut bag_object, 1, shield);
            bag::add(&mut bag_object, 2, hat);

            // adding bag as dynamic fields
            dynamic_field::add(&mut hero.id, b"bag", bag_object);
            transfer::transfer(hero, tx_context::sender(ctx));
            i = i + 1;
        }
    }

    // Repeatedly access hero accessories
    public entry fun access_hero_with_bag_in_dynamic_field(hero_obj_ref: &mut Hero){
        let mut i = 0;
        
        let mut bag_ref: &mut bag::Bag = dynamic_field::borrow_mut(&mut hero_obj_ref.id, b"bag");
        let mut sword: &mut Sword = bag::borrow_mut(bag_ref, 0);
        let mut shield: &mut Shield = bag::borrow_mut(bag_ref, 1);
        let mut hat: &mut Hat = bag::borrow_mut(bag_ref, 2);
        i = i + 1;

        while (i < 10000){
            bag_ref = dynamic_field::borrow_mut(&mut hero_obj_ref.id, b"bag");
            sword = bag::borrow_mut(bag_ref, 0);
            shield = bag::borrow_mut(bag_ref, 1);
            hat = bag::borrow_mut(bag_ref, 2);

            i = i + 1;
        }
    }

    // Repeatedly update hero accessories
    public entry fun update_hero_with_bag_in_dynamic_field(hero_obj_ref: &mut Hero){
        let mut i = 0;
        //First iteration:
        //Get reference to bag within Hero
        let mut bag_ref: &mut bag::Bag = dynamic_field::borrow_mut(&mut hero_obj_ref.id, b"bag");

        //Get references to elements within bag
        let mut sword: &mut Sword = bag::borrow_mut(bag_ref, 0);
        sword.strength = sword.strength + 10;   //note: Must update before getting another mut reference using bag_ref

        let mut shield: &mut Shield = bag::borrow_mut(bag_ref, 1);
        shield.strength = shield.strength + 10;

        let mut hat: &mut Hat = bag::borrow_mut(bag_ref, 2);
        hat.strength = hat.strength + 10;

        i = i + 1;
        while (i < 10000){
            //Get reference to bag within Hero
            bag_ref = dynamic_field::borrow_mut(&mut hero_obj_ref.id, b"bag");

            //Get references to elements within bag
            sword = bag::borrow_mut(bag_ref, 0);
            sword.strength = sword.strength + 10;   //note: Must update before getting another mut reference using bag_ref

            shield = bag::borrow_mut(bag_ref, 1);
            shield.strength = shield.strength + 10;

            hat = bag::borrow_mut(bag_ref, 2);
            hat.strength = hat.strength + 10;

            i = i + 1;
        }
    }
}
