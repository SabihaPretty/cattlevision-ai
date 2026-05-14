-- CreateTable
CREATE TABLE "ScanRecord" (
    "id" TEXT NOT NULL,
    "cattleId" TEXT NOT NULL,
    "deviceId" TEXT NOT NULL,
    "temperature" DOUBLE PRECISION NOT NULL,
    "healthStatus" TEXT NOT NULL,
    "biometricConfidence" DOUBLE PRECISION NOT NULL,
    "muzzleImage" TEXT NOT NULL,
    "note" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ScanRecord_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "ScanRecord" ADD CONSTRAINT "ScanRecord_cattleId_fkey" FOREIGN KEY ("cattleId") REFERENCES "Cattle"("id") ON DELETE CASCADE ON UPDATE CASCADE;
