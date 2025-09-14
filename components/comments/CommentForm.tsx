'use client';

import { postComment } from '@/app/actions/commentActions';
import { useRef, useState, useTransition } from 'react';

export default function CommentForm({ slug }: { slug: string }) {
    const formRef = useRef<HTMLFormElement>(null);
    const [error, setError] = useState<string | null>(null);
    const [isPending, startTransition] = useTransition();

    async function handleFormSubmit(formData: FormData) {
        setError(null);
        
        startTransition(async () => {
            const result = await postComment(slug, formData.get('comment') as string).catch((err) => {
                if (err instanceof Error) {
                    setError(err.message);
                } else {
                    setError("An unknown error occurred.");
                }
            });
            
            if (!error) {
                 formRef.current?.reset();
            }
        });
    }

    return (
        <form ref={formRef} action={handleFormSubmit} className="comment-form">
            <textarea
                name="comment"
                placeholder="Write a comment..."
                required
                className="comment-textarea"
                disabled={isPending}
            />
            <button type="submit" className="auth-button" disabled={isPending}>
                {isPending ? 'Posting...' : 'Comment'}
            </button>
            {error && <p style={{ color: '#DC2626', marginTop: '1rem' }}>{error}</p>}
        </form>
    );
}
