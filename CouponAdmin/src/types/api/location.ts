export interface City {
  id: string;
  name: string;
  status: string;
  createdAt: string;
  updatedAt: string;
  _count?: {
    areas: number;
    users: number;
    sellers: number;
  };
}

export interface Area {
  id: string;
  name: string;
  cityId: string;
  isActive: boolean;
  createdAt: string;
  updatedAt: string;
}

export interface CitiesResponse {
  success: boolean;
  data: City[];
}

export interface CityResponse {
  success: boolean;
  data: City;
}

export interface AreasResponse {
  success: boolean;
  data: Area[];
}

export interface AreaResponse {
  success: boolean;
  data: Area;
}
