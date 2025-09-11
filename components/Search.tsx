'use client';

import React, { useState, useEffect } from 'react';
import Link from 'next/link';
import { allReviews } from '@/lib/data';
import type { Review } from '@/lib/data';
import Image from 'next/image';

type SearchProps = {
  isOpen: boolean;
  onClose: () => void;
};

const CrossIcon = () => <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>;

const Search = ({ isOpen, onClose }: SearchProps) => {
  const [query, setQuery] = useState('');
  const [results, setResults] = useState<Review[]>([]);

  useEffect(() => {
    const handleKeyDown = (event: KeyboardEvent) => {
      if (event.key === 'Escape') {
        onClose();
      }
    };
    window.addEventListener('keydown', handleKeyDown);
    return () => {
      window.removeEventListener('keydown', handleKeyDown);
    };
  }, [onClose]);

  const handleSearch = (event: React.ChangeEvent<HTMLInputElement>) => {
    const newQuery = event.target.value;
    setQuery(newQuery);

    if (newQuery.length > 2) {
      const filteredResults = allReviews.filter(review =>
        review.title.toLowerCase().includes(newQuery.toLowerCase())
      );
      setResults(filteredResults);
    } else {
      setResults([]);
    }
  };
  
  const handleClose = () => {
    setQuery('');
    setResults([]);
    onClose();
  };

  if (!isOpen) {
    return null;
  }

  return (
    <div className="search-overlay" onClick={handleClose}>
      <div className="search-modal" onClick={(e) => e.stopPropagation()}>
        <button className="search-close-button" onClick={handleClose}>
          <CrossIcon />
        </button>
        <input 
          type="search" 
          className="search-input" 
          placeholder="Search for reviews..."
          autoFocus
          value={query}
          onChange={handleSearch}
        />

        <div className="search-results">
          {query.length > 2 && results.length > 0 && (
            <ul>
              {results.map(result => (
                <li key={result.id} className="search-result-item">
                  <Link href={`/reviews/${result.id}`} onClick={handleClose}>
                    <Image 
                      src={result.imageUrl} 
                      alt={result.title}
                      width={100}
                      height={60}
                      className="search-result-image"
                    />
                    <div className="search-result-details">
                      <h4>{result.title}</h4>
                      <p>{result.author} • {result.date}</p>
                    </div>
                  </Link>
                </li>
              ))}
            </ul>
          )}
          {query.length > 2 && results.length === 0 && (
            <p style={{color: 'var(--text-secondary)', marginTop: '3rem'}}>No results found for "{query}"</p>
          )}
        </div>

      </div>
    </div>
  );
};

export default Search;
