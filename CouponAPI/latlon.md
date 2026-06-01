# Sort Sellers by Strict Area Grouping (Pre-calculated Distances)

Based on your feedback, we will:
1. Group sellers strictly by Area.
2. Store `AreaDistance` in the database so we don't calculate distances at runtime.
3. Fallback to alphabetical sorting if a user doesn't have an `areaId`.
4. Integrate an Admin Map so the admin can visually drop a pin for the area's location.
5. Automatically calculate and store distances in the backend when an Area is added/updated with coordinates.

Here is the complete implementation plan.

## Proposed Changes

### 1. Admin Frontend UI (For Context)
*Note: This will guide your frontend work later; we are implementing the backend API in this repository.*
- **Map Integration:** In the Admin "Add Area" and "Edit Area" screens, embed a map (e.g., Google Maps or Mapbox). 
- **Pin Drop:** The admin will drop a pin on the central point of the area.
- **Form Submission:** The frontend will extract the `latitude` and `longitude` from the dropped pin, along with the typed area `name`, and send all of them to the backend API (`POST /admin/cities/:cityId/areas`).

### 2. Database Schema (`prisma/schema.prisma`)
- **[NEW MODEL]** `AreaDistance`:
  ```prisma
  model AreaDistance {
    id         String   @id @default(uuid())
    fromAreaId String
    toAreaId   String
    distanceKm Float

    fromArea Area @relation("FromArea", fields: [fromAreaId], references: [id])
    toArea   Area @relation("ToArea", fields: [toAreaId], references: [id])

    @@unique([fromAreaId, toAreaId])
    @@map("area_distances")
  }
  ```
- **[MODIFY]** `Area` model:
  Add `latitude`, `longitude`, and relations.
  ```prisma
  model Area {
    // ... existing fields
    latitude  Float?
    longitude Float?
    distancesFrom AreaDistance[] @relation("FromArea")
    distancesTo   AreaDistance[] @relation("ToArea")
  }
  ```

### 3. Admin Backend API (`src/modules/admin/cities/*`)
- **[MODIFY]** `cities.validator.ts`: Add `latitude` and `longitude` to `createAreaSchema` and `updateAreaSchema`.
- **[MODIFY]** `cities.service.ts`:
  In `createArea` and `updateArea`:
  - After saving the Area with the provided `latitude` and `longitude` from the map, fetch all other areas in the same city.
  - Calculate the distance from this Area to all other areas.
  - Bulk insert/upsert these records into the `AreaDistance` table for both directions (`NewArea -> ExistingArea` and `ExistingArea -> NewArea`).

### 4. Customer API Controller (`src/modules/sellers/sellers.controller.ts`)
- **[MODIFY]** `getSellersByCityCategory`:
  Extract the `userId` from the authentication token and pass it to the service.
  ```typescript
  getSellersByCityCategory = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const userId = req.user!.userId; 
      const query = req.query as unknown as GetSellersByCityCategoryDto;
      const sellers = await sellersService.getSellersByCityCategory(userId, query);
      sendSuccess(res, sellers.data, 200, sellers.meta);
    } catch (err) {
      next(err);
    }
  };
  ```

### 5. Customer Service Logic (`src/modules/sellers/sellers.service.ts`)
- **[MODIFY]** `getSellersByCityCategory`:
  1. Fetch the user's `areaId` from the `users` table.
  2. If `userAreaId` is found, fetch the ordered list of areas from the `AreaDistance` table:
     ```typescript
     const areaDistances = await prisma.areaDistance.findMany({
       where: { fromAreaId: userAreaId },
       orderBy: { distanceKm: 'asc' },
       select: { toAreaId: true }
     });
     // Array will be: [userAreaId, ...otherAreaIdsInOrder]
     ```
  3. Fetch **all** matching active sellers for the city/category.
  4. Sort the sellers in JavaScript:
     - If the seller's `areaId` is in the ordered list, sort by that index.
     - If `userAreaId` is null, or if the seller's area has no distance calculated, fallback to alphabetical sorting by `businessName`.
  5. Apply pagination to the sorted array using `.slice(skip, skip + limit)`.

## Verification Plan
1. Apply the database migration for `AreaDistance` and Area coordinates.
2. Update the `cities.service.ts` Admin backend logic.
3. Simulate the Admin map selection by using an API client (like Postman) to create a new Area with real Lat/Lng coordinates. Verify `AreaDistance` records are automatically generated in the database.
4. Call `getSellersByCityCategory` with an authenticated User who has an `areaId` set, and verify strict grouping is applied based on the calculated distances.
