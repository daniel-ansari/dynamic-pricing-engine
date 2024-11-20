'use client';

import React, { Suspense } from 'react';
import ProductList from '@/components/ProductList';

export default function Home() {
  return (
    <Suspense fallback={<div>Loading...</div>}>
      <h1 className="text-2xl font-bold mb-4">Product List</h1>
      <ProductList />
    </Suspense>
  );
}
