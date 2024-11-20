type ProductDescriptionProps = {
  name: string;
  category: string;
  price: string;
};

const ProductDescription = ({
  name,
  category,
  price,
}: ProductDescriptionProps) => (
  <div>
    <h1 className="text-3xl font-bold mb-4">{name}</h1>
    <p className="text-lg mb-2">Category: {category}</p>
    <p className="text-xl font-semibold mb-4">Price: ${price}</p>
  </div>
);

export default ProductDescription;
