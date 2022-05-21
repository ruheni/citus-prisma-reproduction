CREATE EXTENSION IF NOT EXISTS citus;

-- add Docker flag to node metadata
UPDATE pg_dist_node_metadata SET metadata=jsonb_insert(metadata, '{docker}', 'true');

-- CreateTable
CREATE TABLE "Company" (
    "id" BIGSERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "image_url" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Company_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Campaign" (
    "id" BIGSERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "cost_model" TEXT NOT NULL,
    "state" TEXT NOT NULL,
    "monthly_budget" BIGINT NOT NULL,
    "blacklisted_site_urls" TEXT[],
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "company_id" BIGINT NOT NULL,

    CONSTRAINT "Campaign_pkey" PRIMARY KEY ("company_id","id")
);

-- CreateTable
CREATE TABLE "Ad" (
    "id" BIGSERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "image_url" TEXT,
    "target_url" TEXT,
    "impressions_count" BIGINT NOT NULL DEFAULT 0,
    "click_count" BIGINT NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "company_id" BIGINT NOT NULL,
    "campaign_company_id" BIGINT,
    "campaign_id" BIGINT,

    CONSTRAINT "Ad_pkey" PRIMARY KEY ("company_id","id")
);

-- CreateTable
CREATE TABLE "Click" (
    "id" BIGSERIAL NOT NULL,
    "clicked_at" TIMESTAMP NOT NULL,
    "site_url" TEXT NOT NULL,
    "cost_per_click_usd" DECIMAL(20,10) NOT NULL,
    "user_ip" INET NOT NULL,
    "user_data" JSONB NOT NULL,
    "company_id" BIGINT NOT NULL,
    "ad_company_id" BIGINT,
    "ad_id" BIGINT,

    CONSTRAINT "Click_pkey" PRIMARY KEY ("company_id","id")
);

-- CreateTable
CREATE TABLE "Impression" (
    "id" BIGSERIAL NOT NULL,
    "seen_at" TIMESTAMP NOT NULL,
    "site_url" TEXT NOT NULL,
    "cost_per_impression" DECIMAL(20,10) NOT NULL,
    "user_ip" INET NOT NULL,
    "user_data" JSONB NOT NULL,
    "company_id" BIGINT NOT NULL,
    "ad_company_id" BIGINT,
    "ad_id" BIGINT,

    CONSTRAINT "Impression_pkey" PRIMARY KEY ("company_id","id")
);

-- AddForeignKey
ALTER TABLE "Campaign" ADD CONSTRAINT "Campaign_company_id_fkey" FOREIGN KEY ("company_id") REFERENCES "Company"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "Ad" ADD CONSTRAINT "Ad_company_id_fkey" FOREIGN KEY ("company_id") REFERENCES "Company"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Ad" ADD CONSTRAINT "Ad_campaign_company_id_campaign_id_fkey" FOREIGN KEY ("campaign_company_id", "campaign_id") REFERENCES "Campaign"("company_id", "id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "Click" ADD CONSTRAINT "Click_company_id_fkey" FOREIGN KEY ("company_id") REFERENCES "Company"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Click" ADD CONSTRAINT "Click_ad_company_id_ad_id_fkey" FOREIGN KEY ("ad_company_id", "ad_id") REFERENCES "Ad"("company_id", "id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "Impression" ADD CONSTRAINT "Impression_company_id_fkey" FOREIGN KEY ("company_id") REFERENCES "Company"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Impression" ADD CONSTRAINT "Impression_ad_company_id_ad_id_fkey" FOREIGN KEY ("ad_company_id", "ad_id") REFERENCES "Ad"("company_id", "id") ON DELETE NO ACTION ON UPDATE NO ACTION;
