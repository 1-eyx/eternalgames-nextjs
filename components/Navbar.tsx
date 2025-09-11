'use client'; 

import React, { useState, useEffect } from 'react';
import Link from 'next/link';
import Search from './Search';
import { ThemeToggle } from './ThemeToggle';
import UserProfile from './UserProfile';

const SearchIcon = () => (
    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
);

const Navbar = () => {
    const [scrolled, setScrolled] = useState(false);
    const [isSearchOpen, setIsSearchOpen] = useState(false);

    useEffect(() => {
        const handleScroll = () => { setScrolled(window.scrollY > 50); };
        window.addEventListener('scroll', handleScroll);
        return () => window.removeEventListener('scroll', handleScroll);
    }, []);

    const openSearch = () => setIsSearchOpen(true);
    const closeSearch = () => setIsSearchOpen(false);

    return (
        <>
            <header className={`navbar ${scrolled ? 'scrolled' : ''}`}>
                <div className="container nav-container">
                    <Link href="/" className="nav-logo no-underline">∞</Link>
                    <nav>
                        <ul className="nav-links">
                            <li><Link href="/reviews">Reviews</Link></li>
                            <li><Link href="/news">News</Link></li>
                            <li><Link href="/articles">Articles</Link></li>
                            <li><Link href="/releases">Releases</Link></li>/
                        </ul>
                    </nav>
                    <div style={{ display: 'flex', alignItems: 'center', gap: '2rem' }}>
                        <ThemeToggle />
                        <UserProfile />
                        <button className="nav-search" onClick={openSearch} aria-label="Open search">
                            <SearchIcon />
                        </button>
                    </div>
                </div>
            </header>
            <Search isOpen={isSearchOpen} onClose={closeSearch} />
        </>
    );
};

export default Navbar;