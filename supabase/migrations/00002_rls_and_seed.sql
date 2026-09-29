-- ENABLE ROW LEVEL SECURITY
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.farms ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.fields ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.crops ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.services ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.pricing_rules ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.zones ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.availability ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.bookings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.booking_status_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.payments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.booking_media ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.routes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.route_stops ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.promotions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.app_media ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.branding ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.app_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.support_requests ENABLE ROW LEVEL SECURITY;

-- POLICIES FOR PROFILES
CREATE POLICY "Profiles viewable by self and admins" ON public.profiles
    FOR SELECT USING (auth.uid() = id OR EXISTS (
        SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role IN ('admin', 'super_admin')
    ));

CREATE POLICY "Users can update own profile" ON public.profiles
    FOR UPDATE USING (auth.uid() = id);

-- POLICIES FOR FARMS
CREATE POLICY "Customers can manage own farms" ON public.farms
    FOR ALL USING (owner_id = auth.uid() OR EXISTS (
        SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role IN ('admin', 'super_admin')
    ));

-- POLICIES FOR FIELDS
CREATE POLICY "Customers can manage own fields" ON public.fields
    FOR ALL USING (EXISTS (
        SELECT 1 FROM public.farms WHERE farms.id = fields.farm_id AND farms.owner_id = auth.uid()
    ) OR EXISTS (
        SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role IN ('admin', 'super_admin', 'operator')
    ));

-- POLICIES FOR PUBLIC DATA (crops, services, pricing, zones, availability, branding, app_media)
CREATE POLICY "Public read for crops" ON public.crops FOR SELECT USING (true);
CREATE POLICY "Public read for services" ON public.services FOR SELECT USING (true);
CREATE POLICY "Public read for pricing_rules" ON public.pricing_rules FOR SELECT USING (true);
CREATE POLICY "Public read for zones" ON public.zones FOR SELECT USING (true);
CREATE POLICY "Public read for availability" ON public.availability FOR SELECT USING (true);
CREATE POLICY "Public read for branding" ON public.branding FOR SELECT USING (true);
CREATE POLICY "Public read for app_media" ON public.app_media FOR SELECT USING (true);
CREATE POLICY "Public read for app_settings" ON public.app_settings FOR SELECT USING (true);

-- POLICIES FOR BOOKINGS
CREATE POLICY "Customers view and create own bookings" ON public.bookings
    FOR ALL USING (customer_id = auth.uid() OR operator_id IN (
        SELECT id FROM public.operators WHERE user_id = auth.uid()
    ) OR EXISTS (
        SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role IN ('admin', 'super_admin')
    ));

-- POLICIES FOR PAYMENTS
CREATE POLICY "Customers view own payments" ON public.payments
    FOR SELECT USING (customer_id = auth.uid() OR EXISTS (
        SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role IN ('admin', 'super_admin')
    ));

-- POLICIES FOR NOTIFICATIONS
CREATE POLICY "Users manage own notifications" ON public.notifications
    FOR ALL USING (user_id = auth.uid());

-- SEED DATA

-- CROPS SEED DATA
INSERT INTO public.crops (id, name, description, image_url, icon, active, sort_order) VALUES
('00000000-0000-0000-0000-000000000101', 'Maíz', 'Cultivo de maíz blanco y amarillo.', 'https://images.unsplash.com/photo-1551754655-cd27e38d2076', 'corn', true, 1),
('00000000-0000-0000-0000-000000000102', 'Melón', 'Cultivo de melón para exportación.', 'https://images.unsplash.com/photo-1571575173700-afb9492e6a50', 'melon', true, 2),
('00000000-0000-0000-0000-000000000103', 'Caña de azúcar', 'Campos de caña de azúcar.', 'https://images.unsplash.com/photo-1527847263472-aa5338d178b8', 'grass', true, 3),
('00000000-0000-0000-0000-000000000104', 'Pastos', 'Pastizales para ganadería.', 'https://images.unsplash.com/photo-1500382017468-9049fed747ef', 'eco', true, 4),
('00000000-0000-0000-0000-000000000105', 'Café', 'Cafetales de alta montaña.', 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd', 'coffee', true, 5),
('00000000-0000-0000-0000-000000000106', 'Tomate', 'Hortaliza de tomate industrial.', 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea', 'tomato', true, 6),
('00000000-0000-0000-0000-000000000107', 'Hortalizas', 'Verduras variadas y legumbres.', 'https://images.unsplash.com/photo-1540420773420-3366772f4999', 'vegetables', true, 7)
ON CONFLICT (id) DO NOTHING;

-- SERVICES SEED DATA
INSERT INTO public.services (id, name, description, service_type, image_url, icon, active, sort_order) VALUES
('00000000-0000-0000-0000-000000000201', 'Fumigación', 'Aplicación precisa y uniforme de agroquímicos.', 'fumigation', 'https://images.unsplash.com/photo-1508614589041-895b88991e3e', 'spray', true, 1),
('00000000-0000-0000-0000-000000000202', 'Fertilización foliar', 'Mejora la nutrición y rendimiento de tus cultivos.', 'fertilization', 'https://images.unsplash.com/photo-1530836369250-ef72a3f5cda8', 'water_drop', true, 2),
('00000000-0000-0000-0000-000000000203', 'Esparcimiento de granulados', 'Distribución eficiente de sólidos y semillas.', 'spreading', 'https://images.unsplash.com/photo-1625246333195-78d9c38ad449', 'grain', true, 3),
('00000000-0000-0000-0000-000000000204', 'Monitoreo agrícola', 'Conoce mejor el estado multiespectral de tu campo.', 'monitoring', 'https://images.unsplash.com/photo-1527977966376-1c8408f9f108', 'camera', true, 4)
ON CONFLICT (id) DO NOTHING;

-- ZONES SEED DATA
INSERT INTO public.zones (id, name, description, travel_fee, active) VALUES
('00000000-0000-0000-0000-000000000301', 'Jutiapa', 'Zona central de Jutiapa.', 100.00, true),
('00000000-0000-0000-0000-000000000302', 'Pasaco', 'Zona costera de Pasaco.', 150.00, true),
('00000000-0000-0000-0000-000000000303', 'Moyuta', 'Zona de Moyuta y alrededores.', 120.00, true),
('00000000-0000-0000-0000-000000000304', 'Jalpatagua', 'Zona de Jalpatagua.', 110.00, true)
ON CONFLICT (id) DO NOTHING;

-- PRICING RULES SEED DATA
INSERT INTO public.pricing_rules (id, service_id, price_per_manzana, price_per_hectare, travel_fee, active) VALUES
('00000000-0000-0000-0000-000000000401', '00000000-0000-0000-0000-000000000201', 150.00, 214.60, 100.00, true),
('00000000-0000-0000-0000-000000000402', '00000000-0000-0000-0000-000000000202', 175.00, 250.37, 100.00, true),
('00000000-0000-0000-0000-000000000403', '00000000-0000-0000-0000-000000000203', 160.00, 228.91, 100.00, true),
('00000000-0000-0000-0000-000000000404', '00000000-0000-0000-0000-000000000204', 120.00, 171.68, 100.00, true)
ON CONFLICT (id) DO NOTHING;

-- APP SETTINGS SEED DATA
INSERT INTO public.app_settings (key, value, type) VALUES
('default_currency', '"GTQ"'::jsonb, 'string'),
('default_area_unit', '"manzanas"'::jsonb, 'string'),
('manzana_conversion', '6988.96'::jsonb, 'number'),
('hectare_conversion', '10000.00'::jsonb, 'number'),
('default_deposit_percentage', '25'::jsonb, 'number'),
('support_phone', '"+502 5555 1234"'::jsonb, 'string'),
('support_whatsapp', '"+502 5555 1234"'::jsonb, 'string'),
('support_email', '"soporte@idrone.gt"'::jsonb, 'string'),
('company_name', '"iDrone Guatemala"'::jsonb, 'string')
ON CONFLICT (key) DO UPDATE SET value = EXCLUDED.value;

-- BRANDING SEED DATA
INSERT INTO public.branding (id, primary_color, secondary_color, accent_color, active) VALUES
('00000000-0000-0000-0000-000000000501', '#063F35', '#159A6B', '#8DDE3F', true)
ON CONFLICT (id) DO NOTHING;
