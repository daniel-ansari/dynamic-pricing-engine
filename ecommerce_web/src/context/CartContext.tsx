"use client";

import React, { createContext, useState, useContext } from "react";

interface CartContextType {
  cartId: string | null;
  setCartId: React.Dispatch<React.SetStateAction<string | null>>;
  updated: boolean | null;
  setUpdated: React.Dispatch<React.SetStateAction<boolean | null>>;
}

const CartContext = createContext<CartContextType | undefined>(undefined);

export const CartProvider = ({ children }: { children: React.ReactNode }) => {
  const [cartId, setCartId] = useState<string | null>(null);
  const [updated, setUpdated] = useState<boolean | null>(false);

  return (
    <CartContext.Provider value={{ cartId, setCartId, updated, setUpdated }}>
      {children}
    </CartContext.Provider>
  );
};

export const useCartContext = () => {
  const context = useContext(CartContext);
  if (!context) {
    throw new Error("useCartContext must be used within a CartProvider");
  }
  return context;
};
