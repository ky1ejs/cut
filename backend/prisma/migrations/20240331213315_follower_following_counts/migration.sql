-- AlterTable
ALTER TABLE "User" ADD COLUMN     "followerCount" INTEGER NOT NULL DEFAULT 0,
ADD COLUMN     "followingCount" INTEGER NOT NULL DEFAULT 0;

CREATE OR REPLACE FUNCTION update_follower_count()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE "User"
        SET "followerCount" = "followerCount" + 1
        WHERE id = NEW."followingId";

        UPDATE "User"
        SET "followingCount" = "followingCount" + 1
        WHERE id = NEW."followerId";
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE "User"
        SET "followerCount" = "followerCount" - 1
        WHERE id = OLD."followingId";

        UPDATE "User"
        SET "followingCount" = "followingCount" - 1
        WHERE id = OLD."followerId";
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_follower_counts_insert
AFTER INSERT ON "Follow"
FOR EACH ROW
EXECUTE FUNCTION update_follower_count();

CREATE TRIGGER update_follower_counts_delete
AFTER DELETE ON "Follow"
FOR EACH ROW
EXECUTE FUNCTION update_follower_count();

