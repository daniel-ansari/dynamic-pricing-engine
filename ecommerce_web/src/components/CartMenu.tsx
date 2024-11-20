"use client";

import { useState, useEffect } from "react";
import { useCartContext } from "@/context/CartContext";
import Link from "next/link";

const CartMenu = () => {
  const { cartId, updated, setUpdated } = useCartContext();
  const [cartDetails, setCartDetails] = useState<any | null>(null);
  const [isDropdownOpen, setIsDropdownOpen] = useState(false);

  useEffect(() => {
    const fetchCartDetails = async () => {
      if (updated) {
        if (cartId) {
          try {
            const res = await fetch(
              `${process.env.NEXT_PUBLIC_API_URL}/api/cart/${cartId}`
            );
            if (res.ok) {
              const data = await res.json();
              setCartDetails(data.cart);
            }
          } catch (err) {
            console.error("Error fetching cart details:", err);
          }
        } else {
          setCartDetails(null);
        }
        setUpdated(false);
      }
    };

    fetchCartDetails();
  }, [cartId, updated]);

  const handleMouseEnter = () => {
    setIsDropdownOpen(true);
  };

  const handleMouseLeave = () => {
    setIsDropdownOpen(false);
  };

  const totalQuantity = cartDetails?.total_quantity || 0;

  return (
    <div className="w-full flex justify-between items-center px-4 py-2 bg-gray-100 relative">
      {/* Logo Section */}
      <div>
        <Link href="/">
          <h1 className="text-2xl font-bold">Home</h1>
        </Link>
      </div>

      {/* Cart Section */}
      <div
        className="relative flex items-center"
        onMouseEnter={handleMouseEnter}
        onMouseLeave={handleMouseLeave}>
        <Link href="/cart">
          <div className="relative cursor-pointer">
            <div className="w-8 h-8 bg-gray-800 text-white flex items-center justify-center rounded-full">
              🛒
            </div>
            <span
              className="absolute -top-1 -right-1 bg-red-600 text-white text-xs font-bold w-5 h-5 flex items-center justify-center rounded-full"
              title="Cart Items">
              {totalQuantity}
            </span>
          </div>
        </Link>
      </div>
      {isDropdownOpen && (
        <div className="absolute top-10 right-0 w-64 bg-white shadow-lg rounded-lg border border-gray-200 p-4 z-10">
          <h3 className="text-lg font-semibold mb-2">Cart Items</h3>
          {cartDetails?.order_items && cartDetails.order_items.length > 0 ? (
            <ul className="space-y-2">
              {cartDetails.order_items.slice(0, 5).map((item: any) => (
                <li
                  key={item.id}
                  className="flex justify-between items-center border-b pb-1 last:border-none">
                  <div>
                    <p className="text-sm font-medium">{item.product.name}</p>
                    <p className="text-xs text-gray-500">
                      Qty: {item.quantity}
                    </p>
                  </div>
                  <p className="text-sm font-bold">${item.price}</p>
                </li>
              ))}
              {cartDetails.order_items.length > 5 && (
                <p className="text-sm text-gray-500 mt-2">
                  + {cartDetails.order_items.length - 5} more items
                </p>
              )}
            </ul>
          ) : (
            <p className="text-gray-500 text-sm">Your cart is empty</p>
          )}
        </div>
      )}
    </div>
  );
};

export default CartMenu;
