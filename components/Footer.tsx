// components/Footer.tsx
import Link from 'next/link';
import React from 'react';

const SocialIcon: React.FC<{ path: string }> = ({ path }) => (
    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="currentColor"><path d={path}/></svg>
);

const Footer = () => {
    return (
        <footer className="footer">
            <div className="container footer-grid">
                <div className="footer-column">
                    <h4>Navigation</h4>
                    <ul className="footer-links">
                        <li><Link href="/reviews" className="no-underline">Reviews</Link></li>
                        <li><Link href="/news" className="no-underline">News</Link></li>
                        <li><Link href="/features" className="no-underline">Features</Link></li>
                        <li><Link href="/video" className="no-underline">Video</Link></li>
                        <li><Link href="/about" className="no-underline">About Us</Link></li>
                    </ul>
                </div>
                <div className="footer-column">
                    <h4>Follow Us</h4>
                    <div className="social-links">
                        <a href="#" aria-label="Twitter" className="no-underline"><SocialIcon path="M23 3a10.9 10.9 0 0 1-3.14 1.53 4.48 4.48 0 0 0-7.86 3v1A10.66 10.66 0 0 1 3 4s-4 9 5 13a11.64 11.64 0 0 1-7 2c9 5 20 0 20-11.5a4.5 4.5 0 0 0-.08-.83A7.72 7.72 0 0 0 23 3z"/></a>
                        <a href="#" aria-label="Twitch" className="no-underline"><SocialIcon path="M21 2H3v16h5v4l4-4h5l4-4V2zm-10 9V7m5 4V7"/></a>
                        <a href="#" aria-label="YouTube" className="no-underline"><SocialIcon path="M21.58 7.19a2.5 2.5 0 0 0-1.76-1.77C18.25 5 12 5 12 5s-6.25 0-7.82.42a2.5 2.5 0 0 0-1.76 1.77A26.12 26.12 0 0 0 2 12s0 4.25.42 5.81a2.5 2.5 0 0 0 1.76 1.77C5.75 20 12 20 12 20s6.25 0 7.82-.42a2.5 2.5 0 0 0 1.76-1.77A26.12 26.12 0 0 0 22 12s0-4.25-.42-4.81zM9.75 15.5v-7l6 3.5-6 3.5z"/></a>
                    </div>
                </div>
                <div className="footer-column">
                    <h4>Join The Newsletter</h4>
                    <p>Get the latest gaming chronicles delivered to your inbox.</p>
                    <form className="newsletter-form">
                        <input type="email" placeholder="your.email@example.com" className="newsletter-input" />
                        <button type="submit" className="newsletter-button">Subscribe</button>
                    </form>
                </div>
            </div>
        </footer>
    );
};

export default Footer;