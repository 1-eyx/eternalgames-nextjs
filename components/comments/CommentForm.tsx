'use client';

import { postComment } from '@/app/actions/commentActions';
import { useRef, useState } from 'react';

export default function CommentForm({ slug }: { slug: string }) {
    const formRef = useRef<HTMLFormElement>(null);
    const [error, setError] = useState<string | null>(null);

    async function handleFormSubmit(formData: FormData) {
        setError(null);
        try {
            await postComment(slug, formData.get('comment') as string);
            formRef.current?.reset();
        } catch (err) {
            if (err instanceof Error) {
                setError(err.message);
            }
        }
    }

    return (
        <form ref={formRef} action={handleFormSubmit} className="comment-form">
            <textarea
                name="comment"
                placeholder="Write a comment..."
                required
                className="comment-textarea"
            />
            <button type="submit" className="auth-button">Comment</button>
            {error && <p style={{ color: 'red', marginTop: '1rem' }}>{error}</p>}
        </form>
    );
}
