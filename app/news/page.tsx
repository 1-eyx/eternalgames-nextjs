import { newsItems } from '@/lib/data';
import Image from 'next/image';
import Link from 'next/link';

const NewsCard = ({ item }: { item: (typeof newsItems)[0] }) => (
    <Link href={`/news/${item.slug}`} className="no-underline news-card-link">
        <div className="news-card">
            <div className="news-card-image-container">
                <Image src={item.imageUrl} alt={item.title} fill style={{objectFit: 'cover'}} className="news-card-image" placeholder="blur" blurDataURL={item.blurDataURL}/>
            </div>
            <div className="news-card-content">
                <p className="news-card-category">{item.category}</p>
                <h3>{item.title}</h3>
            </div>
        </div>
    </Link>
)

export default function NewsPage() {
    return (
        <div className="container page-container">
            <h1 className="page-title">Newsfeed</h1>
            <div className="news-grid">
                {newsItems.map(item => <NewsCard key={item.id} item={item} />)}
            </div>
        </div>
    );
}
