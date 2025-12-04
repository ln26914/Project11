module move_gas_optimization::F_delete_hero_with_obj_bag_wrapped{
    use sui::object_bag;

    public struct Hero has key, store{
        id: UID,
        bag: object_bag::ObjectBag
    }

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

    // Creates a single object that has a bag as a wrapped element
    // Also attaches 3 accessories to bag within
    public entry fun create_hero_with_wrapped_object_bag(ctx: &mut TxContext){
        let bag_object = object_bag::new(ctx);

        //1) Create hero (bag included as field)
        let mut hero = Hero{
            id: object::new(ctx),
            bag: bag_object
        };
        //2) Create accessories and attach to bag
        // creating hero attributes
        let mut sword = Sword{id: object::new(ctx), strength: 0};
        let mut shield = Shield{id: object::new(ctx), strength: 0};
        let mut hat = Hat{id: object::new(ctx), strength: 0};
        
        // adding hero attributes to bag
        object_bag::add(&mut hero.bag, 0, sword);
        object_bag::add(&mut hero.bag, 1, shield);
        object_bag::add(&mut hero.bag, 2, hat);

        //3) Transfer object to user
        transfer::transfer(hero, tx_context::sender(ctx));
    }

    public entry fun delete_hero_with_object_bag_wrapped(mut hero: Hero){
        //1) Delete_bag_contents
        delete_bag_contents(&mut hero);
        
        //2) Unpack and delete Hero
        let Hero{id, bag} = hero;
        object::delete(id);

        //3) Delete ObjectBag
        object_bag::destroy_empty(bag);
    }

    public fun delete_bag_contents(hero_obj_ref: &mut Hero){
        //1) Set up mut_ref to bag using borrow_mut
        let mut bag_ref: &mut object_bag::ObjectBag = &mut hero_obj_ref.bag;
        //2) Call delete on accessories within bag
        delete_sword_from_bag(bag_ref);
        delete_shield_from_bag(bag_ref);
        delete_hat_from_bag(bag_ref);
    }
    
    public fun delete_sword_from_bag(bag_ref: &mut object_bag::ObjectBag){
        //1) Unpack Sword
        let Sword {id, strength:_} = object_bag::remove(bag_ref, 0);
        //2) Delete ID
        object::delete(id);
    }

    public fun delete_shield_from_bag(bag_ref: &mut object_bag::ObjectBag){
        //1) Unpack Sword
        let Shield {id, strength:_} = object_bag::remove(bag_ref, 1);
        //2) Delete ID
        object::delete(id);
    }

    public fun delete_hat_from_bag(bag_ref: &mut object_bag::ObjectBag){
        //1) Unpack Sword
        let Hat {id, strength:_} = object_bag::remove(bag_ref, 2);
        //2) Delete ID
        object::delete(id);
    }
}
