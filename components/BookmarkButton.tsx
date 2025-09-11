'use client';

import React from 'react';
import { useUserStore } from '@/lib/store';

const BookmarkIcon = ({ isBookmarked }: { isBookmarked: boolean }) => (
    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24" fill={isBookmarked ? "currentColor" : "none"} stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
        <path d="M19 21l-7-5-7 5V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z"></path>
    </svg>
);

const BookmarkButton = ({ articleId }: { articleId: number }) => {
    const { bookmarks, toggleBookmark } = useUserStore();
    const isBookmarked = bookmarks.includes(articleId);

    const handleClick = (e: React.MouseEvent) => {
        e.preventDefault();
        e.stopPropagation();
        toggleBookmark(articleId);
    };

    return (
        <button onClick={handleClick} className="bookmark-button" aria-label="Bookmark article">
            <BookmarkIcon isBookmarked={isBookmarked} />
        </button>
    );
};

export default BookmarkButton;
