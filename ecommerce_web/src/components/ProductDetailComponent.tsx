"use client";

import { useState } from "react";
import ProductDescription from "@/components/ProductDescription";
import { useCartContext } from "@/context/CartContext";
import { useRouter } from "next/navigation";

type Product = {
  id: string;
  category: string;
  name: string;
  price: string;
};

type ProductDetailComponentProps = {
  product: Product;
};

const ProductDetailComponent = ({ product }: ProductDetailComponentProps) => {
  const router = useRouter()
  const [quantity, setQuantity] = useState(1);
  const { cartId, setCartId, setUpdated } = useCartContext();

  // Handle Add to Cart
  const handleAddToCart = async () => {
    try {
      const res = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/cart`, {
        method: "POST",
        body: JSON.stringify({
          id: cartId,
          cart: {
            product_id: product.id,
            quantity,
          },
        }),
        headers: {
          "Content-Type": "application/json",
        },
      });

      if (!res.ok) {
        throw new Error("Failed to add to cart");
      }

      const data = await res.json();

      if (data.cart?.id) {
        setCartId(data.cart.id);
        setUpdated(true);

        router.push('/cart');
      }

      console.log("Added to cart:", data);
    } catch (error) {
      console.error("Error adding to cart:", error);
    }
  };

  return (
    <div>
      <ProductDescription
        name={product.name}
        category={product.category}
        price={product.price}
      />

      <div className="mb-4">
        <label
          htmlFor="quantity"
          className="block text-sm font-medium">
          Quantity:
        </label>
        <input
          type="number"
          id="quantity"
          value={quantity}
          onChange={(e) => setQuantity(Number(e.target.value))}
          min="1"
          className="border rounded px-3 py-1 mt-1"
        />
      </div>

      <button
        onClick={handleAddToCart}
        className="bg-blue-600 text-white px-4 py-2 rounded">
        Add to Cart
      </button>
    </div>
  );
};

export default ProductDetailComponent;
