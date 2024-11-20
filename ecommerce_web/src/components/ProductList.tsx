'use client';

import React, { useEffect, useState } from 'react';
import { useSearchParams, useRouter } from 'next/navigation';
import Link from 'next/link';

type Product = {
  id: string;
  category: string;
  name: string;
  price: string;
};

type PaginationLinks = {
  first: string | null;
  prev: string | null;
  next: string | null;
  last: string | null;
};

const ProductList: React.FC = () => {
  const [products, setProducts] = useState<Product[]>([]);
  const [links, setLinks] = useState<PaginationLinks>({
    first: null,
    prev: null,
    next: null,
    last: null,
  });
  const [loading, setLoading] = useState(false);
  const searchParams = useSearchParams();
  const router = useRouter();

  const page = parseInt(searchParams.get('page') || '1');
  const perPage = parseInt(searchParams.get('per_page') || '10');

  const fetchProducts = async () => {
    setLoading(true);
    try {
      const res = await fetch(
        `${process.env.NEXT_PUBLIC_API_URL}/api/products?per_page=${perPage}&page=${page}`,
        { cache: 'no-store' }
      );
      const data = await res.json();
      setProducts(data.products);
      setLinks(data.meta.links);
    } catch (err) {
      console.error('Error fetching products:', err);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchProducts();
  }, [page, perPage]);

  const handleNavigate = (url: string | null) => {
    if (url) {
      const searchParams = new URL(url).search;
      router.push(searchParams);
    }
  };

  return (
    <div>
      <div className="flex items-center mb-4">
        <label htmlFor="per-page" className="mr-2 font-medium">
          Items per page:
        </label>
        <select
          id="per-page"
          value={perPage}
          onChange={(e) =>
            router.push(`/?per_page=${e.target.value}&page=1`)
          }
          className="border rounded px-2 py-1"
        >
          <option value="10">10</option>
          <option value="20">20</option>
          <option value="50">50</option>
        </select>
      </div>

      {loading ? (
        <p>Loading...</p>
      ) : (
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
          {products.map((product) => (
            <div
              key={product.id}
              className="border rounded-lg shadow p-4 bg-white hover:shadow-lg transition"
            >
              <h2 className="text-xl font-semibold">{product.name}</h2>
              <p className="text-gray-500">Category: {product.category}</p>
              <p className="text-gray-900 font-bold">Price: ${product.price}</p>
              <Link
                href={`/products/${product.id}`}
                className="text-blue-500 hover:text-blue-700"
              >
                View Details
              </Link>
            </div>
          ))}
        </div>
      )}

      <div className="mt-4 flex gap-2">
        <button
          onClick={() => handleNavigate(links.first)}
          disabled={!links.first}
          className={`px-4 py-2 rounded ${
            links.first
              ? 'bg-blue-600 text-white hover:bg-blue-700'
              : 'bg-gray-300 text-gray-600 cursor-not-allowed'
          }`}
        >
          First
        </button>
        <button
          onClick={() => handleNavigate(links.prev)}
          disabled={!links.prev}
          className={`px-4 py-2 rounded ${
            links.prev
              ? 'bg-blue-600 text-white hover:bg-blue-700'
              : 'bg-gray-300 text-gray-600 cursor-not-allowed'
          }`}
        >
          Prev
        </button>
        <button
          onClick={() => handleNavigate(links.next)}
          disabled={!links.next}
          className={`px-4 py-2 rounded ${
            links.next
              ? 'bg-blue-600 text-white hover:bg-blue-700'
              : 'bg-gray-300 text-gray-600 cursor-not-allowed'
          }`}
        >
          Next
        </button>
        <button
          onClick={() => handleNavigate(links.last)}
          disabled={!links.last}
          className={`px-4 py-2 rounded ${
            links.last
              ? 'bg-blue-600 text-white hover:bg-blue-700'
              : 'bg-gray-300 text-gray-600 cursor-not-allowed'
          }`}
        >
          Last
        </button>
      </div>
    </div>
  );
};

export default ProductList;
