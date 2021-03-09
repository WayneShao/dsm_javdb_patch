#!/usr/bin/php
<?php

require_once(dirname(__FILE__) . '/../util_themoviedb.php');
require_once(dirname(__FILE__) . '/../search.inc.php');
require_once(dirname(__FILE__) . '/../syno_file_assets/douban.php');

$SUPPORTED_TYPE = array('tvshow', 'tvshow_episode');
$SUPPORTED_PROPERTIES = array('title');

//=========================================================
// douban begin
//=========================================================
function ProcessDouban($input, $lang, $type, $limit, $search_properties, $allowguess, $id)
{
    $title  = $input['title'];
    $year   = ParseYear($input['original_availa ble']);
    $lang   = ConvertToAPILang($lang);
    if (!$lang) {
        return array();
    }

    //$query_data = json_decode( HTTPGETReques t('http: //api.9hut.cn/douban.php?q=' . $title ), true );
    $query_data = getRequest('https://m.douban.com/search/?query=' . $title . '&type=movie');
    $detailPath = array();
    preg_match_all('/\/movie\/subject\/[0-9]+/', $query_data, $detailPath);

    //Get metadata
    return GetMetadataDouban($detailPath[0], $lang);
}
function ProcessDoubanId($input, $lang, $type, $limit, $search_properties, $allowguess, $id)
{
    $title  = $input['title'];
    $year   = ParseYear($input['original_availa ble']);
    $lang   = ConvertToAPILang($lang);
    if (!$lang) {
        return array();
    }

    //$query_data = json_decode( HTTPGETReques t('http: //api.9hut.cn/douban.php?q=' . $title ), true );
    //$query_data = getRequest('https://m.douban.com/search/?query=' . $title . '&type=movie');
    $query_data = getRequest('https://movie.douban.com/subject/' . $title);
    $detailPath = array();
    preg_match_all('/\/movie\/subject\/[0-9]+/', $query_data, $detailPath);

    //Get metadata
    return GetMetadataDouban($detailPath[0], $lang);
}
//=========================================================
// douban end
//=========================================================
function GetEpisodeRawData($tv_data, $season, $episode, $lang)
{
    return GetTvRawdata(
        "episode",
        array(
            'id' => $tv_data->id,
            'season' => $season,
            'episode' => $episode,
            'lang' => $lang
        ),
        DEFAULT_EXPIRED_TIME
    );
}

function GetTvInfo($tv_data, $season, $episode, $data, $lang)
{
    // Fill tvshow information
    $data = ParseTVData($tv_data, $data);

    // Fill episode information
    $list = array();

    if (is_numeric($season) && is_numeric($episode)) {
        $episode_data = GetEpisodeRawData($tv_data, $season, $episode, $lang);
        if ($episode_data) {
            $item = ParseEpisodeData($tv_data, $episode_data, array());
            $list[] = array(
                'season' => $item['season'],
                'episode' => array($item)
            );
        }
    }

    $data['extra'][TV_PLUGINID]['list'] = $list;

    return $data;
}

function ParseTvData($tv_data, $data)
{
    $data['title'] = $tv_data->name;
    $data['original_title'] = $tv_data->original_name;
    $data['original_available'] = $tv_data->first_air_date;
    $data['summary'] = RemoveControlCharacter($tv_data->overview);

    $extra = array();
    if (isset($tv_data->poster_path)) {
        $extra['poster'] = array(BANNER_URL . $tv_data->poster_path);
    }
    if (isset($tv_data->backdrop_path)) {
        $extra['backdrop'] = array(BACKDROUP_URL . $tv_data->backdrop_path);
    }
    $data['extra'][TV_PLUGINID] = $extra;
    return $data;
}


function GetEpisodeInfo($tv_data, $season, $episode, $data, $lang)
{
    // Fill episode information
    $episode_data = GetEpisodeRawData($tv_data, $season, $episode, $lang);
    if ($episode_data) {
        $data = ParseEpisodeData($tv_data, $episode_data, $data);
    }

    // Fill tvshow information
    $data['title'] = $tv_data->name;
    $data['extra'][TV_PLUGINID]['tvshow'] = ParseTvData($tv_data, array());

    return $data;
}

function ParseEpisodeData($tv_data, $episode_data, $data)
{
    $data['season']             = (int)$episode_data->season_number;
    $data['episode']            = (int)$episode_data->episode_number;
    $data['tagline']            = trim((string)$episode_data->name);
    $data['original_available'] = trim((string)$episode_data->air_date);
    $data['summary']            = RemoveControlCharacter($episode_data->overview);
    $data['genre']              = ParseGenre($tv_data);
    $data['certificate']        = ParseCertificate($tv_data);

    if ($episode_data->credits) {
        $data = GetCastInfo($episode_data->credits, $data);
    }

    $extra = array();
    $extra['reference'] = ParseReference($tv_data);
    if ((float) $tv_data->vote_average) {
        $extra['rating'] = array('themoviedb_tv' => (float) $tv_data->vote_average);
    }
    if ((string)$episode_data->still_path) {
        $extra['poster'] = array(BANNER_URL . (string)$episode_data->still_path);
    }
    $data['extra'][TV_PLUGINID] = $extra;

    return $data;
}


function GetCastInfo($cast_data, $data)
{
    // actor
    if (!$data['actor']) {
        $data['actor'] = array();
    }
    foreach ($cast_data->cast as $item) {
        if (!in_array($item->name, $data['actor'])) {
            array_push($data['actor'], $item->name);
        }
    }
    foreach ($cast_data->guest_stars as $item) {
        if (!in_array($item->name, $data['actor'])) {
            array_push($data['actor'], $item->name);
        }
    }

    // director & writer
    if (!$data['director']) {
        $data['director'] = array();
    }
    if (!$data['writer']) {
        $data['writer'] = array();
    }

    foreach ($cast_data->crew as $item) {
        if (strcasecmp($item->department, 'Directing') == 0) {
            if (!in_array($item->name, $data['director'])) {
                array_push($data['director'], $item->name);
            }
        }
        if (strcasecmp($item->department, 'Writing') == 0) {
            if (!in_array($item->name, $data['writer'])) {
                array_push($data['writer'], $item->name);
            }
        }
    }

    return $data;
}

function ParseGenre($tv_data)
{
    $genre = array();
    foreach ($tv_data->genres as $item) {
        if (!in_array($item->name, $genre)) {
            array_push($genre, $item->name);
        }
    }
    return $genre;
}

function ParseCertificate($tv_data)
{
    $certificate = array();
    foreach ($tv_data->content_ratings->results as $item) {
        if ('' === $item->rating) {
            continue;
        }
        $name = strcasecmp($item->iso_3166_1, 'us') == 0 ? 'USA' : $item->iso_3166_1;
        $certificate[$name] = $item->rating;
    }
    return $certificate;
}

function ParseReference($tv_data)
{
    $ref = array();

    $ref['themoviedb_tv'] = $tv_data->id;
    if ($tv_data->external_ids) {
        $ids = $tv_data->external_ids;
        if ($ids->imdb_id) {
            $ref['imdb'] = $ids->imdb_id;
        }
    }
    return $ref;
}

/**
 * @brief get metadata for multiple movies
 * @param $query_data [in] a array contains multiple movie item
 * @param $lang [in] a language
 * @return [out] a result array
 */
function GetMetadata($query_data, $season, $episode, $lang, $type)
{
    global $DATA_TEMPLATE;

    // Foreach query result
    $result = array();
    foreach ($query_data as $item) {
        // If languages are different, skip it
        if (0 != strcmp($item['lang'], $lang)) {
            continue;
        }

        // Copy template
        $data = $DATA_TEMPLATE;

        // Get tv
        $tv_data = GetTvRawdata("tv", array('id' => $item['id'], 'lang' => $item['lang']), DEFAULT_EXPIRED_TIME);
        if (!$tv_data) {
            continue;
        }

        switch ($type) {
            case 'tvshow':
                $data = GetTvInfo($tv_data, $season, $episode, $data, $lang);
                break;
            case 'tvshow_episode':
                $data = GetEpisodeInfo($tv_data, $season, $episode, $data, $lang);
                break;
        }

        // Append to result
        $result[] = $data;
    }

    return $result;
}

function ProcessTMDB($input, $lang, $type, $limit, $search_properties, $allowguess, $id)
{
    $title = $input['title'];
    $year = ParseYear($input['original_available']);
    $lang = ConvertToAPILang($lang);
    $season  = $input['season'];
    $episode = $input['episode'];
    if (!$lang) {
        return array();
    }

    if (0 < $id) {
        // if haved id, output metadata directly.
        return GetMetadata(array(array('id' => $id, 'lang' => $lang)), $season, $episode, $lang, $type);
    }

    // year
    if (isset($input['extra']) && count($input['extra']) > 0) {
        $pluginid = array_shift($input['extra']);
        if (!empty($pluginid['tvshow']['original_available'])) {
            $year = ParseYear($pluginid['tvshow']['original_available']);
        }
    }

    // Search
    $query_data = array();
    $titles = GetGuessingList($title, $allowguess);
    foreach ($titles as $checkTitle) {
        if (empty($checkTitle)) {
            continue;
        }
        $query_data = QueryTV($checkTitle, $year, $lang, $limit);
        if (0 < count($query_data)) {
            break;
        }
    }

    // Get metadata
    return GetMetadata($query_data, $season, $episode, $lang, $type);
}

function Process($input, $lang, $type, $limit, $search_properties, $allowguess, $id)
{
    $t1 = microtime(true);
    if ( 'dan' == $lang ) {
        $RET = ProcessDouban($input, $lang, $type, $limit, $search_properties, $allowguess, $id);
    } else {
        $RET = ProcessTMDB($input, $lang, $type, $limit, $search_properties, $allowguess, $id);
    }
    $t2 = microtime(true);
    //error_log(print_r( $_SERVER, true), 3, "/var/packages/VideoStation/target/plugins/syno_themoviedb/my-errors.log");
    //error_log((($t2-$t1)*1000).'ms', 3, "/var/packages/VideoStation/target/plugins/syno_themoviedb/my-errors.log");
    return $RET;
}
PluginRun('Process');
