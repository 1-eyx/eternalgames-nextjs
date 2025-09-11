'use client'; // <-- THIS IS THE FIX

import Link from 'next/link';
import React from 'react';

type TagLinksProps = {
  tags: string[];
  small?: boolean;
};

const TagLinks = ({ tags, small = false }: TagLinksProps) => {
  if (!tags || tags.length === 0) return null;
  
  return (
    <div className={`tag-links-container ${small ? 'small' : ''}`}>
      {tags.slice(0, small ? 2 : tags.length).map(tag => (
        <Link 
            key={tag} 
            href={`/tags/${encodeURIComponent(tag.toLowerCase())}`} 
            className="tag-link no-underline"
            onClick={(e) => e.stopPropagation()} // This now works because it's a Client Component
        >
          {tag}
        </Link>
      ))}
    </div>
  );
};

export default TagLinks;