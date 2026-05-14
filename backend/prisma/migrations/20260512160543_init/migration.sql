-- CreateTable
CREATE TABLE "Cattle" (
    "id" TEXT NOT NULL,
    "cowTag" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "breed" TEXT NOT NULL,
    "age" INTEGER NOT NULL,
    "color" TEXT NOT NULL,
    "weight" DOUBLE PRECISION NOT NULL,
    "owner" TEXT NOT NULL,
    "farm" TEXT NOT NULL,
    "lastTemperature" DOUBLE PRECISION NOT NULL,
    "healthStatus" TEXT NOT NULL,
    "healthScore" INTEGER NOT NULL,
    "biometricConfidence" DOUBLE PRECISION NOT NULL,
    "lastScanTime" TEXT NOT NULL,
    "deviceId" TEXT NOT NULL,
    "muzzleImage" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Cattle_pkey" PRIMARY KEY ("id")
);
