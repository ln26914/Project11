module dynamic_vs_wrap::hero_wrapped_object{

    // Three types of wrapping:
    //      - Direct, through option, and through vector
    // Direct: putting struct or object as field into wrapper object. Best way to object lock
    //          i.e. object cannot be accessed through the chain, only through wrapper obj

    // Through Option: 
    

    public struct Hero has key, store{
        id: UID,
        sword: Sword,
        shield: Shield,
        hat: Hat
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

    // create many objects in loop (100)
    public entry fun create_hero_wrapped_direct(ctx: &mut TxContext){

        let mut i = 0;
        while(i < 150){
            let mut hero = Hero{
                id: object::new(ctx),
                sword: Sword{id: object::new(ctx), strength: 0},
                shield: Shield{id: object::new(ctx), strength: 0},
                hat: Hat{id: object::new(ctx), strength: 0}
            };

            transfer::transfer(hero, tx_context::sender(ctx));  // transferring
            //hero.id.delete();         // deleting
            //transfer::share_object(hero);  // sharing
            i = i + 1;
        }
    }

    public entry fun create_single_wrappedHero(ctx: &mut TxContext){
        let mut hero = Hero{
            id: object::new(ctx),
            sword: Sword{id: object::new(ctx), strength: 0},
            shield: Shield{id: object::new(ctx), strength: 0},
            hat: Hat{id: object::new(ctx), strength: 0}
        };

        transfer::transfer(hero, tx_context::sender(ctx));
    }

    public entry fun update_wrapped_hero(hero: &mut Hero){
        let mut i = 0;
        //let mut test = 0u64;

        while(i < 10000){
            hero.sword.strength = hero.sword.strength + 1;
            
            i = i + 1;
        }
    }

    public entry fun update_all_wrapped_hero(hero: &mut Hero){
        let mut i = 0;

        while(i < 10000){
            hero.sword.strength = hero.sword.strength + 1;
            hero.shield.strength = hero.shield.strength + 1;
            hero.hat.strength = hero.hat.strength + 1;
            
            i = i + 1;
        };
    }

    // accessing sword field's strength from Hero
    public entry fun access_wrapped_hero(hero: &Hero){
        let mut i = 0;
        let mut test = 0u64;

        while(i < 10000){
            test = hero.sword.strength;

            i = i + 1;
        };
    }

    public entry fun access_all_wrapped_hero(hero: &Hero){
        let mut i = 0;
        let mut test = 0u64;

        while(i < 10000){
            test = hero.sword.strength;
            test = hero.shield.strength;
            test = hero.hat.strength;

            i = i + 1;
        };
    }
    // ***********************************************
    
    // 1. Delete parent without unpacking
    // 2. Unpack parent and then delete parent
    // 3. Unpack parent and then delete parent and children
    /*
    public entry fun delete_wrapped_hero_NoUnpacking(mut hero: Hero, ctx: &mut TxContext){
        object::delete(hero.id);
    }
    */


    public entry fun delete_wrapped_hero_UnpackAndDeleteHero(mut hero: Hero, ctx: &mut TxContext){
        // Unpacking Hero
        let Hero{id, sword, shield, hat} = hero;
        
        // transferring parentless objects (sword, shield, hat)
        transfer::transfer(sword, tx_context::sender(ctx));
        transfer::transfer(shield, tx_context::sender(ctx));
        transfer::transfer(hat, tx_context::sender(ctx));

        // Deleting Hero
        object::delete(id);
    }

    public entry fun delete_wrapped_hero_UnpackParentAndChildren(mut hero: Hero, ctx: &mut TxContext){
        // Unpacking Hero
        let Hero{id: id_hero, sword, shield, hat} = hero;

        // Unpacking Sword, Shield, Hat
        let Sword{id: id_sword, strength:_} = sword;
        let Shield{id: id_shield, strength:_} = shield;
        let Hat{id: id_hat, strength:_} = hat;

        // Deleting Hero
        object::delete(id_hero);

        // Deleting Sword, Shield, Hat
        object::delete(id_sword);
        object::delete(id_shield);
        object::delete(id_hat);
    }




}
