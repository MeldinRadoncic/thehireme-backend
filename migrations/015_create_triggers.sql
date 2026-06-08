-- Migration 015: Create database triggers for maintaining denormalized counters

-- Trigger 1: Update worker.avg_rating and review_count on reviews INSERT/UPDATE/DELETE
CREATE OR REPLACE FUNCTION update_worker_rating_on_review()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE workers
  SET avg_rating = (
        SELECT COALESCE(ROUND(AVG(rating)::NUMERIC, 2), 0.00)
        FROM reviews
        WHERE worker_id = COALESCE(NEW.worker_id, OLD.worker_id)
          AND deleted_at IS NULL
      ),
      review_count = (
        SELECT COUNT(*)
        FROM reviews
        WHERE worker_id = COALESCE(NEW.worker_id, OLD.worker_id)
          AND deleted_at IS NULL
      ),
      updated_at = now()
  WHERE id = COALESCE(NEW.worker_id, OLD.worker_id);
  RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_worker_rating
AFTER INSERT OR UPDATE OR DELETE ON reviews
FOR EACH ROW EXECUTE FUNCTION update_worker_rating_on_review();

-- Trigger 2: Update worker.credit_balance on credit_transactions INSERT
CREATE OR REPLACE FUNCTION update_worker_credit_balance()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE workers
  SET credit_balance = NEW.balance_after,
      updated_at = now()
  WHERE id = NEW.worker_id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_credit_balance
AFTER INSERT ON credit_transactions
FOR EACH ROW EXECUTE FUNCTION update_worker_credit_balance();

-- Trigger 3: Update worker.total_likes on video_watches INSERT
CREATE OR REPLACE FUNCTION update_video_and_worker_likes()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE worker_videos
  SET like_count = like_count + 1,
      updated_at = now()
  WHERE id = NEW.video_id;

  UPDATE workers
  SET total_likes = total_likes + 1,
      updated_at = now()
  WHERE id = NEW.worker_id;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_video_likes
AFTER INSERT ON video_watches
FOR EACH ROW EXECUTE FUNCTION update_video_and_worker_likes();

-- Trigger 4: Update worker.total_views on worker_views INSERT
CREATE OR REPLACE FUNCTION update_worker_total_views()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE workers
  SET total_views = total_views + 1,
      updated_at = now()
  WHERE id = NEW.worker_id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_worker_views
AFTER INSERT ON worker_views
FOR EACH ROW EXECUTE FUNCTION update_worker_total_views();

-- Trigger 5: Update worker image_count and free_images_used
CREATE OR REPLACE FUNCTION update_worker_image_count()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    UPDATE workers
    SET image_count = image_count + 1,
        free_images_used = CASE
          WHEN free_images_used < 5 THEN free_images_used + 1
          ELSE free_images_used
        END,
        updated_at = now()
    WHERE id = NEW.worker_id;
  ELSIF TG_OP = 'UPDATE' AND OLD.deleted_at IS NULL AND NEW.deleted_at IS NOT NULL THEN
    UPDATE workers
    SET image_count = image_count - 1,
        free_images_used = CASE
          WHEN free_images_used > 0 THEN free_images_used - 1
          ELSE 0
        END,
        updated_at = now()
    WHERE id = NEW.worker_id;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_image_count
AFTER INSERT OR UPDATE ON worker_images
FOR EACH ROW EXECUTE FUNCTION update_worker_image_count();

-- Trigger 6: Update worker video_count and free_videos_used
CREATE OR REPLACE FUNCTION update_worker_video_count()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    UPDATE workers
    SET video_count = video_count + 1,
        free_videos_used = CASE
          WHEN free_videos_used < 3 THEN free_videos_used + 1
          ELSE free_videos_used
        END,
        updated_at = now()
    WHERE id = NEW.worker_id;
  ELSIF TG_OP = 'UPDATE' AND OLD.deleted_at IS NULL AND NEW.deleted_at IS NOT NULL THEN
    UPDATE workers
    SET video_count = video_count - 1,
        free_videos_used = CASE
          WHEN free_videos_used > 0 THEN free_videos_used - 1
          ELSE 0
        END,
        updated_at = now()
    WHERE id = NEW.worker_id;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_video_count
AFTER INSERT OR UPDATE ON worker_videos
FOR EACH ROW EXECUTE FUNCTION update_worker_video_count();

-- Trigger 7: Validate max 5 services per worker
CREATE OR REPLACE FUNCTION validate_max_worker_services()
RETURNS TRIGGER AS $$
BEGIN
  IF (SELECT COUNT(*) FROM worker_services WHERE worker_id = NEW.worker_id) >= 5 THEN
    RAISE EXCEPTION 'Worker cannot have more than 5 services';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_validate_max_services
BEFORE INSERT ON worker_services
FOR EACH ROW EXECUTE FUNCTION validate_max_worker_services();
