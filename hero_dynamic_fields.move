module dynamic_vs_wrap::hero_dynamic_fields{

    use sui::dynamic_field;
    //use sui::ofield;
    //

    public struct Hero has key, store{
        id: UID
    }

    // sword, shield, hat
    // They make one struct and name it sword, shield, hat when they add it through dynamic_field::add()
    public struct Accessory has key, store{
        id: UID,
        strength: u64
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
    
    public entry fun create_single_hero_dynamic_fields(ctx: &mut TxContext){
        let mut hero = Hero{id: object::new(ctx)};

        // creating hero attributes
        let mut sword = Sword{id: object::new(ctx), strength: 0};
        let mut shield = Shield{id: object::new(ctx), strength: 0};
        let mut hat = Hat{id: object::new(ctx), strength: 0};

        // adding them as dynamic fields
        dynamic_field::add(&mut hero.id, b"sword", sword);
        dynamic_field::add(&mut hero.id, b"shield", shield);
        dynamic_field::add(&mut hero.id, b"hat", hat);


        transfer::transfer(hero, tx_context::sender(ctx));
        //hero.id.delete();
        //transfer::share_object(hero);
    }

    public entry fun create_hero_dynamic_fields(ctx: &mut TxContext){
        let mut i = 0;
        while (i < 150){
        
            let mut hero = Hero{id: object::new(ctx)};

            let mut sword = Sword{id: object::new(ctx), strength: 0};
            let mut shield = Shield{id: object::new(ctx), strength: 0};
            let mut hat = Hat{id: object::new(ctx), strength: 0};

            dynamic_field::add(&mut hero.id, b"sword", sword);
            dynamic_field::add(&mut hero.id, b"shield", shield);
            dynamic_field::add(&mut hero.id, b"hat", hat);

            //let test:Sword = dynamic_field::remove(&mut hero.id, b"sword");
            //let test: &mut Sword = dynamic_field::remove(&mut hero.id, b"sword");
            //reclaim_sword(&mut sword);
            //dynamic_field::add(&mut hero.id, b"sword", sword);
            

            transfer::transfer(hero, tx_context::sender(ctx));
            //hero.id.delete();
            //transfer::share_object(hero);
            i = i + 1;
        }
    }



    //          updating
    public fun mutate_sword(sword: &mut Sword){
        sword.strength = sword.strength + 1;
    }
    public fun  mutate_shield(shield: &mut Shield){
        shield.strength = shield.strength + 1;
    }
    public fun mutate_hat(hat: &mut Hat){ 
        hat.strength = hat.strength + 1;
    }
    //          accessing
    public fun access_sword(sword: &Sword): u64{
        return sword.strength
    }
    public fun access_shield(shield: &Shield): u64{
        return shield.strength
    }
    public fun access_hat(hat: &Hat): u64{
        return hat.strength
    }
    
    public entry fun update_hero_dynamic_fields(hero: &mut Hero){
        let mut i = 0;
        while(i < 10000){
            mutate_sword(dynamic_field::borrow_mut(&mut hero.id, b"sword"));
            i = i + 1;
        }
        
    }

    public entry fun update_all_hero_dynamic_fields(hero: &mut Hero){
        let mut i = 0;
        while(i < 10000){

            mutate_sword(dynamic_field::borrow_mut(&mut hero.id, b"sword"));
            mutate_shield(dynamic_field::borrow_mut(&mut hero.id, b"shield"));
            mutate_hat(dynamic_field::borrow_mut(&mut hero.id, b"hat"));

            i = i + 1;
        }
        
    }
    // not updating so we use & not &mut
    public entry fun access_hero_dynamic_fields(hero: &Hero){
        let mut i = 0;
        let mut test = 0u64;

        while(i < 10000){
            test = access_sword(dynamic_field::borrow(&hero.id, b"sword"));  // not using &mut since we are just reading it
            i = i + 1;
        }
    }

    public entry fun access_all_hero_dynamic_fields(hero: &Hero){
        let mut i = 0;
        let mut test = 0u64;

        while(i < 10000){
            test = access_sword(dynamic_field::borrow(&hero.id, b"sword"));
            test = access_shield(dynamic_field::borrow(&hero.id, b"shield"));
            test = access_hat(dynamic_field::borrow(&hero.id, b"hat"));

            i = i + 1;
        }
    }
    
    // deleting Dynamic Fields
    public fun delete_sword(hero: &mut Hero){
        let Sword {id, strength:_} = reclaim_sword(hero);
        object::delete(id);
    }
    public fun delete_shield(hero: &mut Hero){
        let Shield{id, strength:_} = reclaim_shield(hero);
        object::delete(id);
    }
    public fun delete_hat(hero: &mut Hero){
        let Hat{id, strength:_} = reclaim_hat(hero);
        object::delete(id);
    }

    public fun delete_hero(hero: Hero){
        let Hero{id} = hero;
        object::delete(id);
    }


    // reclaiming Dynamic Fields
    public fun reclaim_sword(hero: &mut Hero): Sword{
        dynamic_field::remove(&mut hero.id, b"sword")
    }
    public fun reclaim_shield(hero: &mut Hero): Shield{
        dynamic_field::remove(&mut hero.id, b"shield")
    }
    public fun reclaim_hat(hero: &mut Hero): Hat{
        dynamic_field::remove(&mut hero.id, b"hat")
    }

    
    public entry fun delete_hero_withAccessoriesAttached(hero: Hero){
        let Hero{id: id_hero} = hero;
        object::delete(id_hero);
    }
    

    public entry fun delete_hero_detachAndDeleteChildren(mut hero: Hero){
        delete_sword(&mut hero);
        delete_shield(&mut hero);
        delete_hat(&mut hero);

        let Hero{id} = hero;
        object::delete(id);
    }
    
    public entry fun delete_hero_detachButNotDeleteChildren(mut hero: Hero, ctx: &mut TxContext){
        let mut test = reclaim_sword(&mut hero);
        transfer::transfer(test, tx_context::sender(ctx));

        let test2 = reclaim_shield(&mut hero);
        transfer::transfer(test2, tx_context::sender(ctx));

        let test3 = reclaim_hat(&mut hero);
        transfer::transfer(test3, tx_context::sender(ctx));
        // transfer to self
        
        let Hero{id} = hero;
        object::delete(id);
        
    }

    //delete_sword(hero);
    //delete_shield(hero);
    //delete_hat(hero);

    //delete_hero(hero);

     
    /*let Sword{id, strength:_} = reclaim_sword(hero);
        object::delete(id);

        let Shield{id, strength:_} = reclaim_shield(hero);
        object::delete(id);

        let Hat{id_hat, strength:_} = reclaim_hat(hero);
        object::delete(id);*/

        //let Hero {id: id1} = hero;
        //object::delete(id1);

    
    // 1. delete parent with children still attached
    // 2. detach and delete children and then delete parent
    // 3. detach but don't delete children, then delete parent

    // Wrapped
    // 1. delete parent without unpacking
    // 2. unpack parent then delete parent
    // 3. unpack parent, delete parent and then delete children

    

    //public entry fun delete_detachChildren_deleteParent(hero: Hero){
        //delete_sword_shield_hat(hero);
    //}


}   


    // accessing fields uses dynamic_field::borrow and dynamic_field:borrow_mut
    // parameters are (object: &mut UID, name: Name) for both

    /*  EXAMPLE USAGE
    public fun mutate_child_via_parent(parent: &mut Parent) {
        mutate_child(ofield::borrow_mut(&mut parent.id, b"child"));
    }
    */
    // ofield doesn't exist, use dynamic_field or dynamic_object_field::borrow(&mut hero.id, b"accessory")
