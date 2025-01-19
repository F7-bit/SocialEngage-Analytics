use social_media;

--- ENGAGEMENT ANALYSIS --

-- MOST LIKED POST
SELECT post.post_id, COUNT(post_likes.post_id) AS like_count
FROM post
JOIN post_likes ON post.post_id = post_likes.post_id
GROUP BY post.post_id
ORDER BY like_count DESC;

--  TOP USERS BY LIKES RECEIVED
SELECT post.user_id, COUNT(post_likes.post_id) AS total_likes
FROM post
JOIN post_likes ON post.post_id = post_likes.post_id
GROUP BY post.user_id
ORDER BY total_likes DESC;

--  MOST COMMENTED POSTS
SELECT post.post_id, COUNT(comments.comment_id) AS comment_count
FROM post
JOIN comments ON post.post_id = comments.post_id
GROUP BY post.post_id
ORDER BY comment_count DESC;

--  USERS WITH MOST COMMENTS ON THIER POSTS
SELECT post.user_id, COUNT(comments.comment_id) AS total_comments
FROM post
JOIN comments ON post.post_id = comments.post_id
GROUP BY post.user_id
ORDER BY total_comments DESC;

--  MOST LIKED AND COMMENTED POSTS
SELECT 
    p.post_id, 
    like_counts.like_count, 
    comment_counts.comment_count
FROM post p
LEFT JOIN (
    SELECT post_id, COUNT(*) AS like_count
    FROM post_likes
    GROUP BY post_id
) AS like_counts ON p.post_id = like_counts.post_id
LEFT JOIN (
    SELECT post_id, COUNT(*) AS comment_count
    FROM comments
    GROUP BY post_id
) AS comment_counts ON p.post_id = comment_counts.post_id
ORDER BY like_count DESC, comment_count DESC;



--- USER ACTIVITY ANALYSIS

--  MOST ACTIVE USERS(BY NO OF POSTS)
SELECT user_id, COUNT(post_id) AS post_count
FROM post
GROUP BY user_id
ORDER BY post_count DESC;

--  USER WITH MOST FOLLOWERS
SELECT follower_id, COUNT(follower_id) AS followers_count
FROM follows
GROUP BY follower_id
ORDER BY followers_count DESC;

--  USERS WHO FOLLOW OTHERS MOST
SELECT followee_id, COUNT(followee_id) AS following_count
FROM follows
GROUP BY followee_id
ORDER BY following_count DESC;

--  USER WHO COMMENTED THE MOST
SELECT user_id, COUNT(comment_id) AS comment_count
FROM comments
GROUP BY user_id
ORDER BY comment_count DESC;

--  USERS WITH MOST LIKES GIVEN
SELECT user_id, COUNT(post_id) AS likes_given
FROM post_likes
GROUP BY user_id
ORDER BY likes_given DESC;

--- CONTENT ANALYSIS

--  MOST POPULAR HASHTAGS
SELECT 
	hashtag_name AS 'Popular Hashtags', 
    COUNT(post_tags.hashtag_id) AS 'Times Used'
FROM hashtags,post_tags
WHERE hashtags.hashtag_id = post_tags.hashtag_id
GROUP BY post_tags.hashtag_id
ORDER BY COUNT(post_tags.hashtag_id) DESC LIMIT 10;

--  POSTS WITH SPECIFIC HASHTAGS
SELECT *
FROM hashtags
WHERE hashtag_name like '%#follow%';



--  MOST LIKED PHOTO POST
SELECT POST.user_id,POST.post_id,photos.photo_id, COUNT(post_likes.post_id) AS like_count
FROM photos
JOIN post ON photos.post_id = post.post_id
JOIN post_likes ON post.post_id = post_likes.post_id
GROUP BY photos.photo_id
ORDER BY like_count DESC;

-- MOST LIKED VIDEO POST
SELECT POST.user_id,post.post_id,videos.video_id, COUNT(post_likes.post_id) AS like_count
FROM videos
JOIN post ON videos.post_id = post.post_id
JOIN post_likes ON post.post_id = post_likes.post_id
GROUP BY videos.video_id
ORDER BY like_count DESC;

--  USERS WHO LOGGED IN MULTIPLE TIMES
SELECT user_id, COUNT(*) AS login_count
FROM login
GROUP BY user_id
HAVING login_count > 1
ORDER BY login_count DESC;

--  USERS WHO ONLY LIKE PHOTOS (NO COMMENTS)
SELECT DISTINCT post_likes.user_id
FROM post_likes
WHERE post_likes.user_id NOT IN (
    SELECT DISTINCT comments.user_id
    FROM comments
);


--  USERS WITH MO0ST MUTUAL FOLLOWS
SELECT f1.follower_id, COUNT(*) AS mutual_follows
FROM follows f1
JOIN follows f2 ON f1.follower_id = f2.followee_id 
                AND f1.followee_id = f2.follower_id
GROUP BY f1.follower_id
ORDER BY mutual_follows DESC;



--- Content and Hashtag Analysis

--  HASHTAGS USED TOGETHER MOST OFTEN
SELECT ht1.hashtag_name AS hashtag1, ht2.hashtag_name AS hashtag2, COUNT(*) AS pair_count
FROM post_tags as pt1
JOIN post_tags as pt2  ON pt1.post_id = pt2.post_id AND pt1.hashtag_id < pt2.hashtag_id
JOIN hashtags as ht1 ON pt1.hashtag_id = ht1.hashtag_id
JOIN hashtags as ht2 ON pt2.hashtag_id = ht2.hashtag_id
GROUP BY ht1.hashtag_name, ht2.hashtag_name
ORDER BY pair_count DESC;

--  USERS POSTING THE MOST UNIQUE HASHTAGS
SELECT post.user_id, COUNT(DISTINCT post_tags.hashtag_id) AS unique_hashtags
FROM post
JOIN post_tags ON post.post_id = post_tags.post_id
GROUP BY post.user_id
ORDER BY unique_hashtags DESC;


--- USER BEHAVIOUR TRENDS

--  USER POSTING ONLY VIDEOS
SELECT DISTINCT post.user_id
FROM post
LEFT JOIN videos ON post.post_id = videos.post_id
LEFT JOIN photos ON post.post_id = photos.post_id
WHERE photos.post_id IS NULL;

--  USERS POSTING ONLY PHOTOS
SELECT DISTINCT post.user_id
FROM post
LEFT JOIN photos ON post.post_id = photos.post_id
LEFT JOIN videos ON post.post_id = videos.post_id
WHERE videos.post_id IS NULL;


--  CONTENT TYPES (Photos vs Videos) WITH HIGHER LIKES
SELECT 
    CASE 
        WHEN photos.photo_id IS NOT NULL THEN 'Photo'
        WHEN videos.video_id IS NOT NULL THEN 'Video'
    END AS content_type,
    COUNT(post_likes.post_id) AS total_likes
FROM post
LEFT JOIN photos ON post.post_id = photos.post_id
LEFT JOIN videos ON post.post_id = videos.post_id
LEFT JOIN post_likes ON post.post_id = post_likes.post_id
GROUP BY content_type
ORDER BY total_likes DESC;

--  LOGINS FROM MULTIPLE IPs FOR A SINGLE USER
SELECT user_id, COUNT(DISTINCT ip) AS ip_count
FROM login
GROUP BY user_id
HAVING ip_count > 1;

--  MOST POPULAR LOCATIONS
SELECT location, COUNT(*) AS post_count
FROM post
GROUP BY location
ORDER BY post_count DESC;


-- AVERAGE CAPTION LENGTH PER USER
SELECT user_id, AVG(LENGTH(caption)) AS avg_caption_length
FROM post
GROUP BY user_id
ORDER BY avg_caption_length DESC;


-- CAPTIONS CONTAINING SPECIFIC WORDS
SELECT user_id, caption
FROM post
WHERE caption LIKE '%love%' OR caption LIKE '%life%';

--  CAPTIONS BY LENGTH CATEGORY
SELECT 
    CASE 
        WHEN LENGTH(caption) < 30 THEN 'Short'
        WHEN LENGTH(caption) BETWEEN 30 AND 70 THEN 'Medium'
        ELSE 'Long'
    END AS caption_length_category,
    COUNT(*) AS count
FROM post
GROUP BY caption_length_category;








