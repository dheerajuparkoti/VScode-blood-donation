<?php

namespace App\Data;
class DistrictData
{
    public static function getProvinces()
    {
        return [
            1 => 'Pro 1',
            2 => 'Pro 2',
            3 => 'Pro 3',
            4 => 'Pro 4',
            5 => 'Pro 5',
            6 => 'Pro 6',
            7 => 'Pro 7',
            // Add more provinces as needed
        ];
    }

    public static function getDistricts($provinceId)
    {
        // Logic to fetch districts based on the selected province
        // You can use a switch statement or if conditions to return districts
        // based on the selected province
        switch ($provinceId) {
            case 1:
                return [
                     'Bhojpur',
                     'Dhankuta',
                     'Ilam',
                     'Jhapa',
                     'Khotang',
                     'Morang',
                     'Okhaldhunga',
                     'Panchthar',
                     'Sankhuwasabha',
                     'Solukhumbu',
                     'Sunsari',
                     'Taplejung',
                     'Terhathum',
                     'Udayapur'
                ];
            case 2:
                return [
                    'Bara',
                    'Dhanusa',
                    'Mahottari',
                    'Parsa',
                    'Rautahat',
                    'Saptari',
                    'Sarlahi',
                    'Siraha'
                ];
            case 3:
                return [
                    'Bhaktapur',
                    'Chitwan',
                    'Dhading',
                    'Dolakha',
                    'Kathmandu',
                    'Kavrepalanchok',
                    'Lalitpur',
                    'Makwanpur',
                    'Nuwakot',
                    'Ramechhap',
                    'Rasuwa',
                    'Sindhuli',
                    'Sindhupalchok'
                ];
            case 4:
                return [
                    'Baglung',
                    'Gorkha',
                    'Kaski',
                    'Lamjung',
                    'Manang',
                    'Mustang',
                    'Myagdi',
                    'Nawalparasi East',
                    'Parbat',
                    'Syangja',
                    'Tanahu'
                ];
            case 5:
                return [
                    'Arghakhanchi',
                    'Banke',
                    'Bardiya',
                    'Gulmi',
                    'Kapilvastu',
                    'Palpa',
                    'Nawalparasi West',
                    'Rupandehi',
                    'Dang',
                    'Rukum East',
                    'Pyuthan',
                    'Rolpa'
                ];
            case 6:
                return [
                    'Rukum West',
                    'Dailekh',
                    'Dolpa',
                    'Humla',
                    'Jajarkot',
                    'Jumla',
                    'Kalikot',
                    'Mugu',
                    'Salyan',
                    'Surkhet'
                ];
            case 7:
                return [
                     'Achham',
                     'Baitadi',
                     'Bajhang',
                     'Bajura',
                     'Dadeldhura',
                     'Darchula',
                     'Doti',
                     'Kailali',
                     'Kanchanpur'
                ];
            default:
                return [];
        }
        
    }

    public static function getLocalLevels($districtName)
    {
        $localLevels = [];
    
        switch ($districtName) {
            case 'Taplejung':
                $localLevels = [
                    'Sidingba Ru. Mun.',
                    'Meringden Ru. Mun.',
                    'Maiwakhola Ru. Mun.',
                    'Phaktanglung Ru. Mun.',
                    'Sirijangha Ru. Mun.',
                    'Mikwakhola Ru. Mun.',
                    'Aathrai Tribeni Ru. Mun.',
                    'Pathivara Yangwarak Ru. Mun.',
                    'Phungling Mun.'
                ];
                break;
            case 'Sankhuwasabha':
                $localLevels = [
                    'Makalu Ru. Mun.',
                    'Chichila Ru. Mun.',
                    'Silichong Ru. Mun.',
                    'Bhotkhola Ru. Mun.',
                    'Sabhapokhari Ru. Mun.',
                    'Dharmadevi Mun.',
                    'Madi Mun.',
                    'Panchakhapan Mun.',
                    'Chainpur Mun.',
                    'Khandbari Mun.'
                ];
                break;
            case 'Solukhumbu':
                $localLevels = [
                    'Sotang Ru. Mun.',
                    'Mahakulung Ru. Mun.',
                    'Likhupike Ru. Mun.',
                    'Nechasalyan Ru. Mun.',
                    'Thulung Dudhkoshi Ru. Mun.',
                    'Maapya Dudhkoshi Ru. Mun.',
                    'Khumbupasanglahmu Ru. Mun.',
                    'Solududhakunda Mun.'
                ];
                break;
            case 'Okhaldhunga':
                $localLevels = [
                    'Likhu Ru. Mun.',
                    'Molung Ru. Mun.',
                    'Sunkoshi Ru. Mun.',
                    'Champadevi Ru. Mun.',
                    'Chisankhugadhi Ru. Mun.',
                    'Khijidemba Ru. Mun.',
                    'Manebhanjyang Ru. Mun.',
                    'Siddhicharan Mun.'
                ];
                break;
            case 'Khotang':
                $localLevels = [
                    'Sakela Ru. Mun.',
                    'Khotehang Ru. Mun.',
                    'Barahapokhari Ru. Mun.',
                    'Ainselukhark Ru. Mun.',
                    'Rawa Besi Ru. Mun.',
                    'Kepilasagadhi Ru. Mun.',
                    'Jantedhunga Ru. Mun.',
                    'Diprung Chuichumma Ru. Mun.',
                    'Halesi Tuwachung Mun.',
                    'Diktel Rupakot Majhuwagadhi Mun.'
                ];
                break;
            case 'Bhojpur':
                $localLevels = [
                    'Arun Ru. Mun.',
                    'Aamchowk Ru. Mun.',
                    'Hatuwagadhi Ru. Mun.',
                    'Pauwadungma Ru. Mun.',
                    'Temkemaiyung Ru. Mun.',
                    'Salpasilichho Ru. Mun.',
                    'Ramprasad Rai Ru. Mun.',
                    'Shadananda Mun.',
                    'Bhojpur Mun.'
                ];
                break;
            case 'Dhankuta':
                $localLevels = [
                    'Chaubise Ru. Mun.',
                    'Shahidbhumi Ru. Mun.',
                    'Sangurigadhi Ru. Mun.',
                    'Chhathar Jorpati Ru. Mun.',
                    'Pakhribas Mun.',
                    'Mahalaxmi Mun.',
                    'Dhankuta Mun.'
                ];
                break;
                case 'Terhathum':
                    $localLevels = [
                        'Chhathar Ru. Mun.',
                        'Phedap Ru. Mun.',
                        'Aathrai Ru. Mun.',
                        'Menchayam Ru. Mun.',
                        'Laligurans Mun.',
                        'Myanglung Mun.'
                    ];
                    break;
                case 'Panchthar':
                    $localLevels = [
                        'Yangwarak Ru. Mun.',
                        'Hilihang Ru. Mun.',
                        'Falelung Ru. Mun.',
                        'Tumbewa Ru. Mun.',
                        'Kummayak Ru. Mun.',
                        'Miklajung Ru. Mun.',
                        'Falgunanda Ru. Mun.',
                        'Phidim Mun.'
                    ];
                    break;
                case 'Ilam':
                    $localLevels = [
                        'Rong Ru. Mun.',
                        'Mangsebung Ru. Mun.',
                        'Chulachuli Ru. Mun.',
                        'Sandakpur Ru. Mun.',
                        'Fakphokthum Ru. Mun.',
                        'Maijogmai Ru. Mun.',
                        'Illam Mun.',
                        'Mai Mun.',
                        'Deumai Mun.',
                        'Suryodaya Mun.'
                    ];
                    break;
                case 'Jhapa':
                    $localLevels = [
                        'Kamal Ru. Mun.',
                        'Jhapa Ru. Mun.',
                        'Kachankawal Ru. Mun.',
                        'Gauriganj Ru. Mun.',
                        'Barhadashi Ru. Mun.',
                        'Haldibari Ru. Mun.',
                        'Buddhashanti Ru. Mun.',
                        'Shivasataxi Mun.',
                        'Bhadrapur Mun.',
                        'Kankai Mun.',
                        'Birtamod Mun.',
                        'Mechinagar Mun.',
                        'Damak Mun.',
                        'Arjundhara Mun.',
                        'Gauradhaha Mun.'
                    ];
                    break;
                case 'Morang':
                    $localLevels = [
                        'Jahada Ru. Mun.',
                        'Katahari Ru. Mun.',
                        'Gramthan Ru. Mun.',
                        'Dhanpalthan Ru. Mun.',
                        'Kerabari Ru. Mun.',
                        'Budhiganga Ru. Mun.',
                        'Kanepokhari Ru. Mun.',
                        'Miklajung Ru. Mun.',
                        'Letang Mun.',
                        'Sunwarshi Mun.',
                        'Rangeli Mun.',
                        'Patahrishanishchare Mun.',
                        'Biratnagar Met.',
                        'Uralabari Mun.',
                        'Belbari Mun.',
                        'Sundarharaicha Mun.',
                        'Ratuwamai Mun.'
                    ];
                    break;
                case 'Sunsari':
                    $localLevels = [
                        'Gadhi Ru. Mun.',
                        'Koshi Ru. Mun.',
                        'Barju Ru. Mun.',
                        'Harinagar Ru. Mun.',
                        'Dewanganj Ru. Mun.',
                        'Bhokraha Narsing Ru. Mun.',
                        'Ramdhuni Mun.',
                        'Barahchhetra Mun.',
                        'Duhabi Mun.',
                        'Inaruwa Mun.',
                        'Dharan Sub-Met.',
                        'Itahari Sub-Met.'
                    ];
                    break;
                case 'Udayapur':
                    $localLevels = [
                        'Tapli Ru. Mun.',
                        'Rautamai Ru. Mun.',
                        'Udayapurgadhi Ru. Mun.',
                        'Limchungbung Ru. Mun.',
                        'Chaudandigadhi Mun.',
                        'Triyuga Mun.',
                        'Katari Mun.',
                        'Belaka Mun.'
                    ];
                    break;
                case 'Saptari':
                    $localLevels = [
                        'Rajgadh Ru. Mun.',
                        'Rupani Ru. Mun.',
                        'Tirahut Ru. Mun.',
                        'Mahadeva Ru. Mun.',
                        'Bishnupur Ru. Mun.',
                        'Chhinnamasta Ru. Mun.',
                        'Balan Bihul Ru. Mun.',
                        'Tilathi Koiladi Ru. Mun.',
                        'Agnisair Krishna Savaran Ru. Mun.',
                        'Hanumannagar Kankalini Mun.',
                        'Kanchanrup Mun.',
                        'Rajbiraj Mun.',
                        'Khadak Mun.',
                        'Dakneshwori Mun.',
                        'Saptakoshi Ru. Mun.',
                        'Surunga Mun.',
                        'Shambhunath Mun.',
                        'Bode Barsain Mun.'
                    ];
                    break;
                case 'Siraha':
                    $localLevels = [
                        'Aurahi Ru. Mun.',
                        'Naraha Ru. Mun.',
                        'Arnama Ru. Mun.',
                        'Bhagawanpur Ru. Mun.',
                        'Nawarajpur Ru. Mun.',
                        'Bishnupur Ru. Mun.',
                        'Bariyarpatti Ru. Mun.',
                        'Laxmipur Patari Ru. Mun.',
                        'Sakhuwanankarkatti Ru. Mun.',
                        'Mirchaiya Mun.',
                        'Lahan Mun.',
                        'Siraha Mun.',
                        'Dhangadhimai Mun.',
                        'Kalyanpur Mun.',
                        'Karjanha Mun.',
                        'Golbazar Mun.',
                        'Sukhipur Mun.'
                    ];
                    break;
                case 'Dhanusa':
                    $localLevels = [
                        'Aaurahi Ru. Mun.',
                        'Dhanauji Ru. Mun.',
                        'Bateshwor Ru. Mun.',
                        'Janaknandani Ru. Mun.',
                        'Lakshminiya Ru. Mun.',
                        'Mukhiyapatti Musarmiya Ru. Mun.',
                        'Mithila Bihari Mun.',
                        'Kamala Mun.',
                        'Nagarain Mun.',
                        'Ganeshman Charnath Mun.',
                        'Mithila Mun.',
                        'Dhanusadham Mun.',
                        'Bideha Mun.',
                        'Sabaila Mun.',
                        'Hansapur Mun.',
                        'Janakpurdham Sub-Met.',
                        'Sahidnagar Mun.',
                        'Chhireshwornath Mun.'
                    ];
                    break;
                case 'Mahottari':
                    $localLevels = [
                        'Pipra Ru. Mun.',
                        'Sonama Ru. Mun.',
                        'Samsi Ru. Mun.',
                        'Ekdanra Ru. Mun.',
                        'Mahottari Ru. Mun.',
                        'Gaushala Mun.',
                        'Ramgopalpur Mun.',
                        'Aurahi Mun.',
                        'Bardibas Mun.',
                        'Bhangaha Mun.',
                        'Jaleswor Mun.',
                        'Balwa Mun.',
                        'Manra Siswa Mun.',
                        'Matihani Mun.',
                        'Loharpatti Mun.'
                    ];
                    break;
                case 'Sarlahi':
                    $localLevels = [
                        'Dhankaul Ru. Mun.',
                        'Parsa Ru. Mun.',
                        'Bishnu Ru. Mun.',
                        'Ramnagar Ru. Mun.',
                        'Kaudena Ru. Mun.',
                        'Basbariya Ru. Mun.',
                        'Chandranagar Ru. Mun.',
                        'Chakraghatta Ru. Mun.',
                        'Bramhapuri Ru. Mun.',
                        'Barahathawa Mun.',
                        'Haripur Mun.',
                        'Ishworpur Mun.',
                        'Lalbandi Mun.',
                        'Malangawa Mun.',
                        'Kabilasi Mun.',
                        'Bagmati Mun.',
                        'Hariwan Mun.',
                        'Balara Mun.',
                        'Haripurwa Mun.',
                        'Godaita Mun.'
                    ];
                    break;
                case 'Rautahat':
                    $localLevels = [
                        'YeMun.amai Ru. Mun.',
                        'Durga Bhagwati Ru. Mun.',
                        'Katahariya Mun.',
                        'Maulapur Mun.',
                        'Madhav Narayan Mun.',
                        'Gaur Mun.',
                        'Gujara Mun.',
                        'Garuda Mun.',
                        'Ishanath Mun.',
                        'Chandrapur Mun.',
                        'Dewahhi Gonahi Mun.',
                        'Brindaban Mun.',
                        'Rajpur Mun.',
                        'Rajdevi Mun.',
                        'Gadhimai Mun.',
                        'Phatuwa Bijayapur Mun.',
                        'Baudhimai Mun.',
                        'Paroha Mun.'
                    ];
                    break;
                case 'Bara':
                    $localLevels = [
                        'Pheta Ru. Mun.',
                        'Devtal Ru. Mun.',
                        'Prasauni Ru. Mun.',
                        'Suwarna Ru. Mun.',
                        'Baragadhi Ru. Mun.',
                        'Karaiyamai Ru. Mun.',
                        'Parwanipur Ru. Mun.',
                        'Bishrampur Ru. Mun.',
                        'Adarshkotwal Ru. Mun.',
                        'Jitpur Simara Sub-Met.',
                        'Kalaiya Sub-Met.',
                        'Pacharauta Mun.',
                        'Nijgadh Mun.',
                        'Simraungadh Mun.',
                        'Mahagadhimai Mun.',
                        'Kolhabi Mun.'
                    ];
                    break;
                    case 'Parsa': [
                        'Thori Ru. Mun.',
                        'Dhobini Ru. Mun.',
                        'Chhipaharmai Ru. Mun.',
                        'Jirabhawani Ru. Mun.',
                        'Jagarnathpur Ru. Mun.',
                        'Kalikamai Ru. Mun.',
                        'Bindabasini Ru. Mun.',
                        'Pakahamainpur Ru. Mun.',
                        'SakhuwaPrasauni Ru. Mun.',
                        'Paterwasugauli Ru. Mun.',
                        'Birgunj Met.',
                        'Bahudaramai Mun.',
                        'Pokhariya Mun.',
                        'Parsagadhi Mun.'
                    ];
                    break;
                    case 'Dolakha': [
                        'Bigu Ru. Mun.',
                        'Sailung Ru. Mun.',
                        'Melung Ru. Mun.',
                        'Baiteshwor Ru. Mun.',
                        'Tamakoshi Ru. Mun.',
                        'Gaurishankar Ru. Mun.',
                        'Kalinchok Ru. Mun.',
                        'Jiri Mun.',
                        'Bhimeshwor Mun.'
                    ];
                    break;
                    case'Sindhupalchok': [
                        'Jugal Ru. Mun.',
                        'Balefi Ru. Mun.',
                        'Sunkoshi Ru. Mun.',
                        'Helambu Ru. Mun.',
                        'Bhotekoshi Ru. Mun.',
                        'Lisangkhu Pakhar Ru. Mun.',
                        'Indrawati Ru. Mun.',
                        'Tripurasundari Ru. Mun.',
                        'Panchpokhari Thangpal Ru. Mun.',
                        'Chautara SangachokGadhi Mun.',
                        'Barhabise Mun.',
                        'Melamchi Mun.'
                    ];
                    break;
                    case 'Rasuwa': [
                        'Kalika Ru. Mun.',
                        'Naukunda Ru. Mun.',
                        'Uttargaya Ru. Mun.',
                        'Gosaikunda Ru. Mun.',
                        'Amachodingmo Ru. Mun.'
                    ];
                    break;
                    case 'Dhading': [
                        'Gajuri Ru. Mun.',
                        'Galchi Ru. Mun.',
                        'Thakre Ru. Mun.',
                        'Siddhalek Ru. Mun.',
                        'Khaniyabash Ru. Mun.',
                        'Jwalamukhi Ru. Mun.',
                        'GangajaMun.a Ru. Mun.',
                        'Rubi Valley Ru. Mun.',
                        'Tripura Sundari Ru. Mun.',
                        'Netrawati Dabjong Ru. Mun.',
                        'Benighat Rorang Ru. Mun.',
                        'Nilakantha Mun.',
                        'Dhunibesi Mun.'
                    ];
                    break;
                    case 'Nuwakot': [
                        'Kakani Ru. Mun.',
                        'Tadi Ru. Mun.',
                        'Likhu Ru. Mun.',
                        'Myagang Ru. Mun.',
                        'Shivapuri Ru. Mun.',
                        'Kispang Ru. Mun.',
                        'Suryagadhi Ru. Mun.',
                        'Tarkeshwar Ru. Mun.',
                        'Panchakanya Ru. Mun.',
                        'Dupcheshwar Ru. Mun.',
                        'Belkotgadhi Mun.',
                        'Bidur Mun.'
                    ];
                    break;
                    case 'Kathmandu': [
                        'Kirtipur Mun.',
                        'Shankharapur Mun.',
                        'Nagarjun Mun.',
                        'Kageshwori Manahora Mun.',
                        'Dakshinkali Mun.',
                        'Budhanilakantha Mun.',
                        'Tarakeshwor Mun.',
                        'Kathmandu Met.',
                        'Tokha Mun.',
                        'Chandragiri Mun.',
                        'Gokarneshwor Mun.'
                    ];
                    break;
                    case 'Bhaktapur': [
                        'Changunarayan Mun.',
                        'Suryabinayak Mun.',
                        'Bhaktapur Mun.',
                        'Madhyapur Thimi Mun.'
                    ];
                    break;
                    case 'Lalitpur': [
                        'Bagmati Ru. Mun.',
                        'Mahankal Ru. Mun.',
                        'Konjyosom Ru. Mun.',
                        'Lalitpur Met.',
                        'Mahalaxmi Mun.',
                        'Godawari Mun.'
                    ];
                    break;
                    case'Kavrepalanchok': [
                        'Roshi Ru. Mun.',
                        'Temal Ru. Mun.',
                        'Bhumlu Ru. Mun.',
                        'Mahabharat Ru. Mun.',
                        'Bethanchowk Ru. Mun.',
                        'Khanikhola Ru. Mun.',
                        'Chaurideurali Ru. Mun.',
                        'Banepa Mun.',
                        'Mandandeupur Mun.',
                        'Dhulikhel Mun.',
                        'Panauti Mun.',
                        'Namobuddha Mun.',
                        'Panchkhal Mun.'
                    ];
                    break;
                    case 'Ramechhap': [
                        'Sunapati Ru. Mun.',
                        'Doramba Ru. Mun.',
                        'Umakunda Ru. Mun.',
                        'Khadadevi Ru. Mun.',
                        'Gokulganga Ru. Mun.',
                        'Likhu Tamakoshi Ru. Mun.',
                        'Manthali Mun.',
                        'Ramechhap Mun.'
                    ];
                    break;
                    case 'Sindhuli': [
                        'Marin Ru. Mun.',
                        'Phikkal Ru. Mun.',
                        'Tinpatan Ru. Mun.',
                        'Sunkoshi Ru. Mun.',
                        'Golanjor Ru. Mun.',
                        'Ghanglekh Ru. Mun.',
                        'Hariharpurgadhi Ru. Mun.',
                        'Dudhouli Mun.',
                        'Kamalamai Mun.'
                    ];
                    break;
                    case 'Makwanpur': [
                        'Bakaiya Ru. Mun.',
                        'Kailash Ru. Mun.',
                        'Manahari Ru. Mun.',
                        'Bhimphedi Ru. Mun.',
                        'Bagmati Ru. Mun.',
                        'Raksirang Ru. Mun.',
                        'Makawanpurgadhi Ru. Mun.',
                        'Indrasarowar Ru. Mun.',
                        'Hetauda Sub-Met.',
                        'Thaha Mun.'
                    ];
                    break;
                    case 'Chitwan': [
                        'Ichchhyakamana Ru. Mun.',
                        'Bharatpur Met.',
                        'Kalika Mun.',
                        'Khairahani Mun.',
                        'Madi Mun.',
                        'Rapti Mun.',
                        'Ratnanagar Mun.'
                    ];
                    break;
                    case 'Gorkha': [
                        'Gandaki Ru. Mun.',
                        'Dharche Ru. Mun.',
                        'Aarughat Ru. Mun.',
                        'Ajirkot Ru. Mun.',
                        'Sahid Lakhan Ru. Mun.',
                        'Siranchok Ru. Mun.',
                        'Bhimsenthapa Ru. Mun.',
                        'Chum Nubri Ru. Mun.',
                        'Barpak Sulikot Ru. Mun.',
                        'Palungtar Mun.',
                        'Gorkha Mun.'
                    ];
                    break;
                    case 'Manang': [
                        'Chame Ru. Mun.',
                        'Narshon Ru. Mun.',
                        'Narpa Bhumi Ru. Mun.',
                        'Manang Ingshyang Ru. Mun.'
                    ];
                    break;
                    case 'Mustang': [
                        'Thasang Ru. Mun.',
                        'Gharapjhong Ru. Mun.',
                        'Lomanthang Ru. Mun.',
                        'Lo-Ghekar Damodarkunda Ru. Mun.',
                        'Waragung Muktikhsetra Ru. Mun.'
                    ];
                    break;
                    case 'Myagdi': [
                        'Mangala Ru. Mun.',
                        'Malika Ru. Mun.',
                        'Raghuganga Ru. Mun.',
                        'Dhaulagiri Ru. Mun.',
                        'Annapurna Ru. Mun.',
                        'Beni Mun.'
                    ];
                    break;
                    case 'Kaski': [
                        'Rupa Ru. Mun.',
                        'Madi Ru. Mun.',
                        'Annapurna Ru. Mun.',
                        'Machhapuchchhre Ru. Mun.',
                        'Pokhara Met.'
                    ];
                    break;
                    case 'Lamjung': [
                        'Dordi Ru. Mun.',
                        'Dudhpokhari Ru. Mun.',
                        'Marsyangdi Ru. Mun.',
                        'Kwholasothar Ru. Mun.',
                        'Sundarbazar Mun.',
                        'Besishahar Mun.',
                        'Rainas Mun.',
                        'MadhyaNepal Mun.'
                    ];
                    break;
                    case 'Tanahu': [
                        'Ghiring Ru. Mun.',
                        'Devghat Ru. Mun.',
                        'Rhishing Ru. Mun.',
                        'Myagde Ru. Mun.',
                        'Bandipur Ru. Mun.',
                        'Anbukhaireni Ru. Mun.',
                        'Byas Mun.',
                        'Shuklagandaki Mun.',
                        'Bhimad Mun.',
                        'Bhanu Mun.'
                    ];
                    break;
                    case 'Nawalparasi East': [
                        'Baudeekali Ru. Mun.',
                        'Bulingtar Ru. Mun.',
                        'Hupsekot Ru. Mun.',
                        'Binayee Tribeni Ru. Mun.',
                        'Madhyabindu Mun.',
                        'Devchuli Mun.',
                        'Gaidakot Mun.',
                        'Kawasoti Mun.'
                    ];
                    break;
                    case 'Syangja': [
                        'Harinas Ru. Mun.',
                        'Biruwa Ru. Mun.',
                        'Aandhikhola Ru. Mun.',
                        'Phedikhola Ru. Mun.',
                        'Kaligandagi Ru. Mun.',
                        'Arjunchaupari Ru. Mun.',
                        'Putalibazar Mun.',
                        'Bhirkot Mun.',
                        'Galyang Mun.',
                        'Chapakot Mun.',
                        'Waling Mun.'
                    ];
                    break;
                    case 'Parbat': [
                        'Modi Ru. Mun.',
                        'Painyu Ru. Mun.',
                        'Jaljala Ru. Mun.',
                        'Bihadi Ru. Mun.',
                        'Mahashila Ru. Mun.',
                        'Kushma Mun.',
                        'Phalebas Mun.'
                    ];
                    break;
                    case 'Baglung': [
                        'Bareng Ru. Mun.',
                        'Badigad Ru. Mun.',
                        'Nisikhola Ru. Mun.',
                        'Kanthekhola Ru. Mun.',
                        'Tara Khola Ru. Mun.',
                        'Taman Khola Ru. Mun.',
                        'JaiMun.i Mun.',
                        'Baglung Mun.',
                        'Galkot Mun.',
                        'Dhorpatan Mun.'
                    ];
                    break;
                    case'Rukum East': [
                        'Bhume Ru. Mun.',
                        'Sisne Ru. Mun.',
                        'Putha Uttarganga Ru. Mun.'
                    ];
                    break;
                    case 'Rolpa': [
                        'Madi Ru. Mun.',
                        'Thawang Ru. Mun.',
                        'Sunchhahari Ru. Mun.',
                        'Lungri Ru. Mun.',
                        'Gangadev Ru. Mun.',
                        'Tribeni Ru. Mun.',
                        'Pariwartan Ru. Mun.',
                        'Runtigadi Ru. Mun.',
                        'Sunil Smriti Ru. Mun.',
                        'Rolpa Mun.'
                    ];
                    break;
                    case 'Pyuthan': [
                        'Ayirabati Ru. Mun.',
                        'Gaumukhi Ru. Mun.',
                        'Jhimruk Ru. Mun.',
                        'Naubahini Ru. Mun.',
                        'Mandavi Ru. Mun.',
                        'Mallarani Ru. Mun.',
                        'Sarumarani Ru. Mun.',
                        'Pyuthan Mun.',
                        'Sworgadwary Mun.'
                    ];
                    break;
                    case 'Gulmi': [
                        'Ruru Ru. Mun.',
                        'Isma Ru. Mun.',
                        'Madane Ru. Mun.',
                        'Malika Ru. Mun.',
                        'Chatrakot Ru. Mun.',
                        'Dhurkot Ru. Mun.',
                        'Satyawati Ru. Mun.',
                        'Chandrakot Ru. Mun.',
                        'Kaligandaki Ru. Mun.',
                        'Gulmidarbar Ru. Mun.',
                        'Resunga Mun.',
                        'Musikot Mun.'
                    ];
                    break;
                    case'Arghakhanchi': [
                        'Panini Ru. Mun.',
                        'Chhatradev Ru. Mun.',
                        'Malarani Ru. Mun.',
                        'Bhumekasthan Mun.',
                        'Sitganga Mun.',
                        'Sandhikharka Mun.'
                    ];
                    break;
                    case'Palpa': [
                        'Rambha Ru. Mun.',
                        'Tinau Ru. Mun.',
                        'Nisdi Ru. Mun.',
                        'Mathagadhi Ru. Mun.',
                        'Ribdikot Ru. Mun.',
                        'Purbakhola Ru. Mun.',
                        'Bagnaskali Ru. Mun.',
                        'Rainadevi Chhahara Ru. Mun.',
                        'Tansen Mun.',
                        'Rampur Mun.'
                    ];
                    break;
                    case'Nawalparasi West': [
                        'Sarawal Ru. Mun.',
                        'Susta Ru. Mun.',
                        'Pratappur Ru. Mun.',
                        'Palhi Nandan Ru. Mun.',
                        'Bardaghat Mun.',
                        'Sunwal Mun.',
                        'Ramgram Mun.'
                    ];
                    break;
                    case'Rupandehi': [
                        'Kanchan Ru. Mun.',
                        'Siyari Ru. Mun.',
                        'Rohini Ru. Mun.',
                        'Gaidahawa Ru. Mun.',
                        'Omsatiya Ru. Mun.',
                        'Sudhdhodhan Ru. Mun.',
                        'Mayadevi Ru. Mun.',
                        'Marchawari Ru. Mun.',
                        'Kotahimai Ru. Mun.',
                        'Sammarimai Ru. Mun.',
                        'Butwal Sub-Met.',
                        'Lumbini Sanskritik Mun.',
                        'Devdaha Mun.',
                        'Sainamaina Mun.',
                        'Siddharthanagar Mun.',
                        'Tillotama Mun.'
                    ];
                    break;
                    case'Kapilvastu': [
                        'Yashodhara Ru. Mun.',
                        'Bijayanagar Ru. Mun.',
                        'Mayadevi Ru. Mun.',
                        'Suddhodhan Ru. Mun.',
                        'Shivaraj Mun.',
                        'Kapilbastu Mun.',
                        'Buddhabhumi Mun.',
                        'Maharajgunj Mun.',
                        'Banganga Mun.',
                        'Krishnanagar Mun.'
                    ];
                    break;
                    case'Dang': [
                        'Babai Ru. Mun.',
                        'Gadhawa Ru. Mun.',
                        'Rapti Ru. Mun.',
                        'Rajpur Ru. Mun.',
                        'Dangisharan Ru. Mun.',
                        'Shantinagar Ru. Mun.',
                        'Banglachuli Ru. Mun.',
                        'Tulsipur Sub-Met.',
                        'Ghorahi Sub-Met.',
                        'Lamahi Mun.'
                    ];
                    break;
                    case'Banke': [
                        'Khajura Ru. Mun.',
                        'Janki Ru. Mun.',
                        'Baijanath Ru. Mun.',
                        'Duduwa Ru. Mun.',
                        'Narainapur Ru. Mun.',
                        'Rapti Sonari Ru. Mun.',
                        'Kohalpur Mun.',
                    ];
                    break;
                    case'Bardiya': [
                        'Geruwa Ru. Mun.',
                        'Badhaiyatal Ru. Mun.',
                        'Thakurbaba Mun.',
                        'Bansagadhi Mun.',
                        'Barbardiya Mun.',
                        'Rajapur Mun.',
                        'Madhuwan Mun.',
                        'Gulariya Mun.'
                    ];
                    break;
                    case'Dolpa': [
                        'Kaike Ru. Mun.',
                        'Jagadulla Ru. Mun.',
                        'Mudkechula Ru. Mun.',
                        'Dolpo Buddha Ru. Mun.',
                        'Shey Phoksundo Ru. Mun.',
                        'Chharka Tangsong Ru. Mun.',
                        'Tripurasundari Mun.',
                        'Thuli Bheri Mun.'
                    ];
                    break;
                    case'Mugu': [
                        'Soru Ru. Mun.',
                        'Khatyad Ru. Mun.',
                        'Mugum Karmarong Ru. Mun.',
                        'Chhayanath Rara Mun.'
                    ];
                    break;
                    case'Humla': [
                        'Simkot Ru. Mun.',
                        'Namkha Ru. Mun.',
                        'Chankheli Ru. Mun.',
                        'Tanjakot Ru. Mun.',
                        'Sarkegad Ru. Mun.',
                        'Adanchuli Ru. Mun.',
                        'Kharpunath Ru. Mun.'
                    ];
                    break;
                    case'Jumla': [
                        'Hima Ru. Mun.',
                        'Tila Ru. Mun.',
                        'Sinja Ru. Mun.',
                        'Guthichaur Ru. Mun.',
                        'Tatopani Ru. Mun.',
                        'Patrasi Ru. Mun.',
                        'Kanakasundari Ru. Mun.',
                        'Chandannath Mun.'
                    ];
                    break;
                    case'Kalikot': [
                        'Mahawai Ru. Mun.',
                        'Palata Ru. Mun.',
                        'Naraharinath Ru. Mun.',
                        'Pachaljharana Ru. Mun.',
                        'Subha Kalika Ru. Mun.',
                        'Sanni Tribeni Ru. Mun.',
                        'Khandachakra Mun.',
                        'Raskot Mun.',
                        'Tilagufa Mun.'
                    ];
                    break;
                    case'Dailekh': [
                        'Bhairabi Ru. Mun.',
                        'Mahabu Ru. Mun.',
                        'Gurans Ru. Mun.',
                        'Naumule Ru. Mun.',
                        'Bhagawatimai Ru. Mun.',
                        'Thantikandh Ru. Mun.',
                        'Dungeshwor Ru. Mun.',
                        'Aathabis Mun.',
                        'Dullu Mun.',
                        'Chamunda Bindrasaini Mun.',
                        'Narayan Mun.'
                    ];
                    break;
                    case'Jajarkot': [
                        'Kuse Ru. Mun.',
                        'Shiwalaya Ru. Mun.',
                        'Barekot Ru. Mun.',
                        'Junichande Ru. Mun.',
                        'Nalagad Mun.',
                        'Bheri Mun.',
                        'Chhedagad Mun.'
                    ];
                    break;
                    case 'Rukum West': [
                        'Tribeni Ru. Mun.',
                        'Sani Bheri Ru. Mun.',
                        'Banfikot Ru. Mun.',
                        'Aathbiskot Mun.',
                        'Chaurjahari Mun.',
                        'Musikot Mun.'
                    ];
                    break;
                    case'Salyan': [
                        'Kumakh Ru. Mun.',
                        'Darma Ru. Mun.',
                        'Kapurkot Ru. Mun.',
                        'Kalimati Ru. Mun.',
                        'Tribeni Ru. Mun.',
                        'Chhatreshwori Ru. Mun.',
                        'Siddha Kumakh Ru. Mun.',
                        'Sharada Mun.',
                        'Bangad Kupinde Mun.',
                        'Bagchaur Mun.'
                    ];
                    break;
                    case'Surkhet': [
                        'Chaukune Ru. Mun.',
                        'Simta Ru. Mun.',
                        'Chingad Ru. Mun.',
                        'Barahtal Ru. Mun.',
                        'Gurbhakot Mun.',
                        'Panchpuri Mun.',
                        'Bheriganga Mun.',
                        'Lekbeshi Mun.',
                        'Birendranagar Mun.'
                    ];
                    break;
                    case'Bajura': [
                        'Gaumul Ru. Mun.',
                        'Himali Ru. Mun.',
                        'Jagannath Ru. Mun.',
                        'Khaptad Chhededaha Ru. Mun.',
                        'Swami Kartik Khaapar Ru. Mun.',
                        'Badimalika Mun.',
                        'Tribeni Mun.',
                        'Budhiganga Mun.',
                        'Budhinanda Mun.'
                    ];
                    break;
                    case'Bajhang': [
                        'Masta Ru. Mun.',
                        'Thalara Ru. Mun.',
                        'Talkot Ru. Mun.',
                        'Surma Ru. Mun.',
                        'SaiPaal Ru. Mun.',
                        'Durgathali Ru. Mun.',
                        'Bithadchir Ru. Mun.',
                        'Kedarseu Ru. Mun.',
                        'Khaptadchhanna Ru. Mun.',
                        'Chabispathivera Ru. Mun.',
                        'JayaPrithivi Mun.',
                        'Bungal Mun.'
                    ];
                    break;
                    case 'Darchula': [
                        'Lekam Ru. Mun.',
                        'Naugad Ru. Mun.',
                        'Byas Ru. Mun.',
                        'Dunhu Ru. Mun.',
                        'Marma Ru. Mun.',
                        'Apihimal Ru. Mun.',
                        'Malikaarjun Ru. Mun.',
                        'Mahakali Mun.',
                        'Shailyashikhar Mun.'
                    ];
                    break;
                    case'Baitadi': [
                        'Sigas Ru. Mun.',
                        'Shivanath Ru. Mun.',
                        'Surnaya Ru. Mun.',
                        'Dilasaini Ru. Mun.',
                        'Pancheshwar Ru. Mun.',
                        'Dogadakedar Ru. Mun.',
                        'Melauli Mun.',
                        'Dasharathchanda Mun.',
                        'Purchaudi Mun.',
                        'Patan Mun.'
                    ];
                    break;
                    case'Dadeldhura': [
                        'Alital Ru. Mun.',
                        'Ajaymeru Ru. Mun.',
                        'Bhageshwar Ru. Mun.',
                        'Nawadurga Ru. Mun.',
                        'Ganayapdhura Ru. Mun.',
                        'Amargadhi Mun.',
                        'Parashuram Mun.'
                    ];
                    break;
                    case'Doti': [
                        'Sayal Ru. Mun.',
                        'Adharsha Ru. Mun.',
                        'Jorayal Ru. Mun.',
                        'Badikedar Ru. Mun.',
                        'Purbichauki Ru. Mun.',
                        'K I Singh Ru. Mun.',
                        'Bogtan Foodsil Ru. Mun.',
                        'Dipayal Silgadi Mun.',
                        'Shikhar Mun.'
                    ];
                    break;
                    case'Achham': [
                        'Mangalsen Mun.',
                        'Panchadeval Binayak Mun.',
                        'Kamalbazar Mun.',
                        'Sanfebagar Mun.',
                        'Chaurpati Mun.',
                        'Ramaroshan Mun.',
                        'Bannigadhi Jayagadh Mun.',
                        'Ramaroshan Mun.'
                    ];
                    break;
                    case'Kailali': [
                        'Bhajani Mun.',
                        'Mohanyal Mun.',
                        'Lamki Chuha Mun.',
                        'Ghodaghodi Mun.',
                        'Tikapur Mun.',
                        'Janaki Mun.',
                        'Godavari Mun.',
                        'Gauri Ganga Mun.',
                        'Bardagoriya Mun.',
                        'Joshipur Mun.'
                    ];
                    break;
                    case'Kanchanpur': [
                        'Shuklaphanta Mun.',
                        'Bedkot Mun.',
                        'Beldandi Mun.',
                        'Punarwas Mun.',
                        'Mahakali Mun.',
                        'Krishnapur Mun.',
                        'Belauri Mun.',
                        'Panchakule Mun.',
                        'Shreemadi Mun.'
                    ];

        }
        
        return $localLevels;
    }
}