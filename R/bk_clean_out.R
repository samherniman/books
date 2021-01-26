#' Clean data from the outlet data
#'
#' @param x outlet dataframe
#'
#' @return a dataframe containing data from the out tables
#' @export
#'
#' @examples
bk_clean_out <- function(x){
  x %>%
    janitor::clean_names() %>%
    mutate(
      library_id = coalesce(fscskey, k_dectop),
      outlet_id = coalesce(fscs_seq, k_seq),
      lib_name = coalesce(libname, lib_name),
      lib_city = coalesce(city, lib_city),
      lib_address = coalesce(address, lib_addr),
      lib_zip = coalesce(zip, lib_zip),
      lib_zip4 = coalesce(zip4, lib_zip4),
      lib_phone = coalesce(phone, lib_phone),
      lib_county = coalesce(cnty, lib_cnty),
      outlet_type = coalesce(c_out_ty, c_out_typ),
      web_address = coalesce(web_addr, web_adr),
      fips_county = coalesce(cntyfips, fipsco),
      fips_state = coalesce(pub_fips, fipsst),
      geocoding_accuracy_level = coalesce(gal, addrtype),
      # geocoding_match_status = coalesce(galms, )
      year_submission = coalesce(yr_sub, yr)
    ) %>%
    dplyr::select(-c(
      libname, city, address, lib_addr, zip, zip4, phone,
      cnty, lib_cnty, c_out_ty, c_out_typ, web_addr, web_adr, cntyfips, fipsco, pub_fips, fipsst, k_dectop, yr, yr_sub, addrtype, gal
    ),
    fips_place = fipsplac,
    gnis_place = gnisplac,
    obe_region = obereg,
    metro_status_code = c_msa,
    service_area_population = c_ser_pop,
    number_of_bookmobiles = lib_num_bm,
    # outlet_id = k_seq,
    state_abbreviation = stabr,
    # square_feet_imputation_flag = f_sq_ft,
    outlet_square_feet = sq_feet,
    hours_per_year = hours,
    weeks_open_per_year = wks_open,
    change_structure_code = statstru,
    change_name_code = statname,
    change_address_code = stataddr,
    longitude = longitud,
    state_incit = incitsst,
    county_incit = incitsco,
    county_population = cntypop,
    locale_code = locale,
    reap_locale_code = reaplocale,
    census_tract = centract,
    census_block = cenblock,
    congressional_district = cdcode,
    # geocoding_accuracy_level = gal,
    gal_match_status = galms,
    esri_match_status = mstatus,
    postal_match_status = postms
    # c_fscs_meets_pl_definition = c_fscs
    ) %>%
    mutate(
      address_cat = stringr::str_to_title(iconv(glue::glue("{lib_address}, {lib_city}, {state_abbreviation} {lib_zip}")))
    ) %>%
    janitor::remove_empty(c("rows", "cols"), quiet = FALSE) %>%
    janitor::remove_constant()
}
