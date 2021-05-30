# play-store VUE Project

1.install dependencies

 -npm install bootstrap

 -npm install axios

 -npm install jquery popper.js

 -npm run serve
 
 2. create api
 
 -product table : id, title, description, image, price, created_at, updated_at, cart_id
 
 -carts : id, quantity, created_at, updated_at
 
 -product apis:
  
  1. /products [get]
  2. /products/{productId} [get]
  
 -cart apis:
 
  1. /cart [get]
  2. /cart [post]
  3. /cart/{productId} [get]
  4. /cart [get]
 
 
select cp.product_id, sum(cp.quantity), sum(cp.price)
from carts c left join cart_product cp -- on cp.cart_id = c.id
where c.id = 1
group by cp.product_id;

//    @Query("select new com.stone.store.play.shop.payload.ShopRes.CartDto(cp.product.id, sum(cp.quantity), sum(cp.price)) " +
//            "from Cart c left join c.cartProducts cp where c.user.username = :username group by cp.product.id")
//    List<CartDto> findAllByUser(@Param("username") String username);
