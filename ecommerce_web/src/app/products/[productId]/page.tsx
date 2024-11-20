import { Suspense } from "react";
import ProductDetailComponent from "@/components/ProductDetailComponent";

async function fetchProduct(productId: string) {
  const res = await fetch(
    `${process.env.NEXT_PUBLIC_API_URL}/api/products/${productId}`
  );
  if (!res.ok) {
    console.error("Failed to fetch product");
    return null;
  }
  const data = await res.json();
  return data.product;
}

export default async function ProductDetail({
  params,
}: {
  params: Promise<{ productId: string }>;
}) {
  const productId = (await params).productId;

  // Fetch product data on the server side
  const product = await fetchProduct(productId);

  // Handle loading state
  if (!product) {
    return <p>Loading product details...</p>;
  }

  return (
    <Suspense fallback={<div>Loading...</div>}>
      <ProductDetailComponent product={product} />
    </Suspense>
  );
}
