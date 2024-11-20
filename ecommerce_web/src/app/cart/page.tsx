'use client';

import { Suspense, useEffect, useState } from 'react';
import { useCartContext } from '@/context/CartContext';
import { useRouter } from 'next/navigation';

type CartItem = {
  id: string;
  quantity: number;
  price: string;
  product: {
    id: string;
    name: string;
    category: string;
    price: string;
  };
};

type Cart = {
  id: string;
  order_items: CartItem[];
  total_price: string;
  total_quantity: number;
};

const CartPage = () => {
  const router = useRouter();
  const { cartId, setCartId, setUpdated } = useCartContext();
  const [cart, setCart] = useState<Cart | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  // Fetch cart data
  useEffect(() => {
    const fetchCart = async () => {
      if (!cartId) {
        setError('No cart found');
        return;
      }

      try {
        setLoading(true);
        const res = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/cart/${cartId}`);
        if (!res.ok) {
          throw new Error('Failed to fetch cart');
        }
        const data = await res.json();
        setCart(data.cart);
      } catch (err: any) {
        setError(err.message);
      } finally {
        setLoading(false);
      }
    };

    fetchCart();
  }, [cartId]);

  // Place order
  const handlePlaceOrder = async () => {
    if (!cartId) {
      setError('No cart found');
      return;
    }

    try {
      setLoading(true);
      const res = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/orders`, {
        method: 'POST',
        body: JSON.stringify({ cart_id: cartId }),
        headers: {
          'Content-Type': 'application/json',
        },
      });

      if (!res.ok) {
        throw new Error('Failed to place order');
      }

      const data = await res.json();
      setCartId(null);
      setUpdated(true);

      alert(`Order placed successfully! Order ID: ${data.order.id}`);
      router.push('/'); 

    } catch (err: any) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  if (loading) return <p>Loading...</p>;
  if (error) return <p className="text-red-500">Error: {error}</p>;

  return (
    <Suspense fallback={<div>Loading...</div>}>
      <h1 className="text-2xl font-bold mb-4">Your Cart</h1>
      {!cart ? (
        <p>Your cart is empty</p>
      ) : (
        <>
          <ul className="mb-4">
            {cart.order_items.map((item) => (
              <li key={item.id} className="border rounded-lg p-4 mb-2 bg-white shadow">
                <h2 className="text-lg font-semibold">{item.product.name}</h2>
                <p>Category: {item.product.category}</p>
                <p>Price: ${item.product.price}</p>
                <p>Quantity: {item.quantity}</p>
                <p className="font-bold">Total: ${item.price}</p>
              </li>
            ))}
          </ul>
          <p className="text-lg font-bold">Total Price: ${cart.total_price}</p>
          <p className="text-lg">Total Quantity: {cart.total_quantity}</p>
          <button
            onClick={handlePlaceOrder}
            className="bg-blue-600 text-white px-4 py-2 rounded mt-4"
          >
            Place Order
          </button>
        </>
      )}
    </Suspense>
  );
};

export default CartPage;
